from http import HTTPStatus

import boto3

from utils import create_response


def handle_get_harvest_job_status(job_id: str) -> dict:
    """Retrieve and return the status of a MediaPackage harvest job.

    Parameters:
    - job_id (str): The unique identifier for the harvest job.

    Returns:
    - dict: status of the harvest job
    """
    mediapackage_client = boto3.client("mediapackage")

    try:
        response = mediapackage_client.describe_harvest_job(Id=job_id)
        status = response.get('Status')
        return create_response(
            status_code=HTTPStatus.OK,
            body={"jobId": job_id, "status": status}
        )
    except mediapackage_client.exceptions.ClientError as e:
        return create_response(
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            body={"error": str(e)}
        )
