from http import HTTPStatus

from utils import create_response
from lambda_env import LambdaEnv


def handle_get_manifest(event, lambda_environment: LambdaEnv):
    return create_response(
        status_code=HTTPStatus.OK,
        body={"endpoint": lambda_environment.mediapackage_hls_endpoint}
    )
