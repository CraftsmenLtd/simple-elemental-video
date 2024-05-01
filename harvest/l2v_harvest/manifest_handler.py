from lambda_env import LambdaEnv


def handle_get_manifest(event, lambda_environment: LambdaEnv):
    return lambda_environment.mediapackage_hls_endpoint
