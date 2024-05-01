"""API gateway events handler.

Currently, the following endpoints are supported:
    API Endpoints:
    GET /live-streams/manifest (playback the live video feed)
    POST /harvest-jobs (create a media package harvest job)
    GET /harvest-jobs/{jobId}/status (show the status of a specific harvest job)
    GET /videos/{videoId}/manifest (retrieve the manifest for VOD playback)
"""
import base64
import logging
from http import HTTPStatus

from job_create import handle_create_harvest_job
from job_status import handle_get_harvest_job_status
from lambda_env import LambdaEnv
from manifest_handler import handle_get_live_manifest, handle_get_vod_manifest
from scte_handler import handle_send_scte_marker
from utils import create_response

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)


def handler(event, context):
    """Lambda function to handle API Gateway events.

    Parameters:
    - event (dict): The AWS Lambda event object.
    - context (LambdaContext): The Lambda function runtime context.

    Returns:
    - dict: The API Gateway response.
    """
    LOGGER.info("Handling event: %s", event)

    path = event.get("path")
    http_method = event.get("httpMethod", "").upper()

    LOGGER.info("Received %s request for %s", http_method, path)

    lambda_environment = LambdaEnv.get_lambda_env()
    if lambda_environment is None:
        raise KeyError("Failed to parse lambda environment")

    try:
        if path in ["/harvest/jobs", "/harvest/jobs/"] and http_method == "POST":
            return handle_create_harvest_job(event)
        if path.startswith("/harvest/jobs/") and http_method == "GET":
            job_id = path.split("/")[-1]
            return handle_get_harvest_job_status(job_id)
        elif path in ["/live/marker"] and http_method == "POST":
            decoded_bytes = base64.b64decode(event["body"])
            event_body = decoded_bytes.decode('utf-8')
            return handle_send_scte_marker(event_body, lambda_environment)
        elif path in ["/live/manifest"] and http_method == "GET":
            return handle_get_live_manifest(lambda_environment)
        elif path in ["/vod/manifest"] and http_method == "GET":
            return handle_get_vod_manifest(lambda_environment)
    # for unforeseeable scenarios
    except Exception as error:
        LOGGER.exception("Error processing request.", exc_info=error)
        return create_response(
            HTTPStatus.INTERNAL_SERVER_ERROR.value,
            {"error": str(error)}
        )
