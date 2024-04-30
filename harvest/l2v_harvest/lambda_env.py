"""Module for representing a lambda environment object"""

import logging
import os
from typing import Optional

LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.INFO)


class LambdaEnv:
    """
    Class that represents the lambda environment variables.
    """

    def __init__(self):
        self.harvest_role_arn: Optional[str] = None
        self.mediapackage_hls_endpoint: Optional[str] = None
        self.mediapackage_channel_id: Optional[str] = None
        self.medialive_channel_id: Optional[str] = None

    @classmethod
    def get_lambda_env(cls) -> Optional["LambdaEnv"]:
        """Get the env variables and create a LambdaEnv instance

        :return: LambdaEnv instance
        """
        lambda_env = cls()

        try:
            lambda_env.harvest_role_arn = os.environ["harvest_role_arn"]
            lambda_env.mediapackage_hls_endpoint = os.environ[
                "mediapackage_hls_endpoint"]
            lambda_env.mediapackage_channel_id = os.environ["mediapackage_channel_id"]
            lambda_env.medialive_channel_id = os.environ["medialive_channel_id"]
        except KeyError as exc:
            LOGGER.exception(
                "Key error while getting environment variables", exc_info=exc)
            return None

        return lambda_env
