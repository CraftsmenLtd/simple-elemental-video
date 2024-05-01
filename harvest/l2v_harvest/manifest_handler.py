from http import HTTPStatus

from s3_helper import get_last_modified_files
from utils import create_response
from lambda_env import LambdaEnv


def handle_get_live_manifest(lambda_environment: LambdaEnv):
    return create_response(
        status_code=HTTPStatus.OK,
        body={"endpoint": lambda_environment.mediapackage_hls_endpoint}
    )


def handle_get_vod_manifest(lambda_environment: LambdaEnv):
    last_modified_files = get_last_modified_files(
        lambda_environment.harvest_bucket_name,
        suffix="index.m3u8",  # TODO: make dynamic
        num_files=1
    )

    if last_modified_files:
        return create_response(
            status_code=HTTPStatus.OK,
            body={
                "endpoint": f"https://{lambda_environment.vod_bucket_domain_name}/{last_modified_files[0]['Key']}"}
        )
    return create_response(
        status_code=HTTPStatus.NOT_FOUND,
        body={"job": f"L2V jod is not finished yet"}
    )
