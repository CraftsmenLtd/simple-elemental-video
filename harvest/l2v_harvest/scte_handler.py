import json
from http import HTTPStatus

from pydantic import ValidationError
from botocore.exceptions import ClientError
from aws_utils.medialive import MedialiveHelper
from lambda_env import LambdaEnv
from schemas import ScteMarker
from utils import create_response


def handle_send_scte_marker(event, lambda_environment: LambdaEnv) -> dict:
    """Send scte marker to medialive channel

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

    try:
        scte_marker = ScteMarker(**payload)
    except ValidationError:
        return create_response(
            status_code=HTTPStatus.BAD_REQUEST,
            body={"error": "Invalid request payload."}
        )

    try:
        medialive_helper = MedialiveHelper()
        medialive_helper.send_scte_marker(lambda_environment.medialive_channel_id,
                                          scte_marker.scte_marker_id,
                                          scte_marker.ad_duration_in_sec)
        return create_response(
            status_code=HTTPStatus.OK,
            body={"message": "Scte marker sent"}
        )
    except ClientError as e:
        return create_response(
            status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
            body={"error": "Error sending SCTE marker"}
        )
