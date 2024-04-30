import json
import uuid
from http import HTTPStatus

import boto3
from botocore.exceptions import ClientError
from pydantic import ValidationError

from .schemas import HarvestJob
from .utils import create_response


def handle_create_harvest_job(event) -> dict:
    """Create a mediapackage harvest job.

    Parameters:
    - event (dict): The AWS Lambda event object containing the API Gateway
        request details.

    Returns:
    - dict: The API Gateway response containing the status code
        and response body.
    """
    try:
        payload = json.loads(event["body"])
    except KeyError:
        return create_response(
            status_code=HTTPStatus.BAD_REQUEST,
            body={"error": "Request payload is missing."}
        )
    except json.JSONDecodeError:
        return create_response(
            status_code=HTTPStatus.BAD_REQUEST,
            body={"error": "Invalid JSON in request body."}
        )

    job_id = uuid.uuid4()
    payload["jobId"] = job_id

    try:
        harvest_job = HarvestJob(**payload)
    except ValidationError:
        return create_response(
            status_code=HTTPStatus.BAD_REQUEST,
            body={"error": "Invalid request payload."}
        )

    try:
        response = _create_mediapackage_harvest_job(harvest_job)
        return create_response(
            status_code=HTTPStatus.CREATED,
            body=response
        )
    except ClientError as e:
        return create_response(
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            body={"error": f"Error creating harvest job: {str(e)}"}
        )


def _create_mediapackage_harvest_job(harvest_job: HarvestJob):
    """Create a MediaPackage harvest job.

    Parameters:
    - harvest_job (HarvestJob): An object containing all the necessary information
        to create a harvest job. It must have the following attributes:
        - job_id (UUID4): The unique identifier for the harvest job.
        - origin_endpoint_id (str): The ID of the origin endpoint.
        - start_time (datetime): The start time for the job in ISO 8601 format.
        - end_time (datetime): The end time for the job in ISO 8601 format.
        - s3_destination (S3Destination): An object containing S3 destination details,
          which includes:
            - bucket_name (str): The name of the S3 bucket.
            - manifest_key (str): The key for the manifest file.
            - role_arn (str): The ARN of the IAM role with permissions to
                access the bucket.

    Returns:
    - dict: Response from the AWS MediaPackage client's `create_harvest_job` method.

    Raises:
    - ClientError: If the harvest job creation fails.
    """
    mediapackage_client = boto3.client("mediapackage")

    harvest_job_params = {
        "Id": harvest_job.job_id,
        "OriginEndpointId": harvest_job.origin_endpoint_id,
        "StartTime": harvest_job.start_time,
        "EndTime": harvest_job.end_time,
        "S3Destination": {
            "BucketName": harvest_job.s3_destination.bucket_name,
            "ManifestKey": harvest_job.s3_destination.manifest_key,
            "RoleArn": harvest_job.s3_destination.role_arn
        }
    }

    response = mediapackage_client.create_harvest_job(**harvest_job_params)
    return response
