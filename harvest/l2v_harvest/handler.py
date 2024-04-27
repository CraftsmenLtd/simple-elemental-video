"""API gateway events handler.

Currently, the following endpoints are supported:
    API Endpoints:
    GET /live-streams/manifest (playback the live video feed)
    POST /harvest-jobs (create a media package harvest job)
    GET /harvest-jobs/{jobId}/status (show the status of a specific harvest job)
    GET /videos/{videoId}/manifest (retrieve the manifest for VOD playback)
"""
import json
import logging
from http import HTTPStatus

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)


class InvalidPayloadError(Exception):
    """Raise when an invalid payload format is found."""


class InvalidParameterError(Exception):
    """Raise when a parameter cannot be validated."""


def handler(event, context):
    """Lambda function to handle API Gateway events.

    Parameters:
    - event (dict): The AWS Lambda event object.
    - context (LambdaContext): The Lambda function runtime context.

    Returns:
    - dict: The API Gateway response.
    """
    LOGGER.info("Handling event: %s", event)

    route_key = event.get("requestContext", {}).get("routeKey", "")

    LOGGER.info("Received request for %s", route_key)

    try:
        if route_key == "POST /harvest-jobs":
            return handle_create_harvest_job(event)
    # for unforeseeable scenarios
    except Exception as error:
        LOGGER.exception("Error processing request.", exc_info=error)
        return create_response(
            HTTPStatus.INTERNAL_SERVER_ERROR.value,
            {"error": str(error)}
        )


def handle_create_harvest_job(event) -> dict:
    """Create a mediapackage harvest job.

    Parameters:
    - event (dict): The AWS Lambda event object containing the API Gateway
        request details.

    Returns:
    - dict: The API Gateway response containing the status code
        and response body.
    """
    # TODO
    status_code = 201
    response = {}

    return create_response(
        status_code,
        response
    )


def create_response(status_code: int, body: dict) -> dict:
    """Create an API Gateway response.

    Parameters:
    - status_code (int): The HTTP status code.
    - body (dict): The response body.

    Returns:
    - dict: The API Gateway response.
    """
    return {
        "statusCode": status_code,
        "body": json.dumps(body, indent=4, default=str)
    }
