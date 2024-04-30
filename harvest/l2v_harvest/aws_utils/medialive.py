"""AWS medialive functions"""
import datetime
import json
import logging
from typing import Optional

import boto3
from botocore.client import Config
from mypy_boto3_medialive import MediaLiveClient
from mypy_boto3_medialive.type_defs import ScheduleActionTypeDef

BOTO_CONFIG = Config(connect_timeout=15, read_timeout=15)
LOGGER = logging.getLogger()


class MedialiveHelper:

    def __init__(self):
        self._ml_client: Optional[MediaLiveClient] = None

    def set_up(self, profile: str, region: str) -> None:
        """Setup medialive helper

        :param profile:
        :param region:
        :return: None
        """
        aws_session = boto3.session.Session(profile_name=profile)
        self._ml_client: MediaLiveClient = aws_session.client("medialive", region,
                                                              config=BOTO_CONFIG)

    @staticmethod
    def generate_splice_action(splice_event_id: int, start_time: datetime.datetime,
                               duration: int) -> ScheduleActionTypeDef:
        """Generate the splice insert payload for sending SCTE35 marker to medialive channel

        :param splice_event_id: SCTE35 event ID
        :param start_time: medialive schedule start time
        :param duration: schedule duration
        :return:
        """
        start_time_str: str = start_time.strftime("%Y-%m-%dT%H:%M:%SZ")
        return {
            "ActionName": "splice_insert.{}".format(start_time_str),
            "ScheduleActionSettings": {
                "Scte35SpliceInsertSettings": {
                    "SpliceEventId": splice_event_id,
                    "Duration": duration
                }
            },
            "ScheduleActionStartSettings": {
                "FixedModeScheduleActionStartSettings": {
                    "Time": start_time_str
                }
            }
        }

    def send_scte_marker(self, medialive_channel_id: str,
                         splice_event_id: str, ad_length_in_secs: int = 10,
                         start_after_sec=0) -> None:
        """Send SCTE marker to medialive channel

        :param medialive_channel_id: AWS medialive channel ID
        :param splice_event_id: splice event id to send
        :param ad_length_in_secs: splice event duration in seconds
        :param start_after_sec: when the ad break should start
        :return:
        """
        ad_start_time = datetime.datetime.utcnow() + datetime.timedelta(
            seconds=start_after_sec
        )
        duration = ad_length_in_secs * 90000  # duration of ad in sec * (90000 Hz ticks)
        splice_action: ScheduleActionTypeDef = self.generate_splice_action(
            int(splice_event_id),
            ad_start_time,
            int(duration)
        )

        response = self._ml_client.batch_update_schedule(
            ChannelId=medialive_channel_id,
            Creates={"ScheduleActions": [splice_action]}
        )
        logging.info("SCTE-35 markers action %s", json.dumps(response))
