import json

import boto3


MC_CONFIG = """
{
    "Queue": "arn:aws:mediaconvert:ap-south-1:265650111895:queues/Default",
    "UserMetadata": {},
    "Role": "arn:aws:iam::265650111895:role/service-role/MediaConvert_Role",
    "Settings": {
        "TimecodeConfig": {
            "Source": "ZEROBASED"
        },
        "OutputGroups": [
            {
                "CustomName": "MSSN-HLS",
                "Name": "Apple HLS",
                "Outputs": [
                    {
                        "ContainerSettings": {
                            "Container": "M3U8",
                            "M3u8Settings": {}
                        },
                        "VideoDescription": {
                            "CodecSettings": {
                                "Codec": "H_264",
                                "H264Settings": {
                                    "MaxBitrate": 10000,
                                    "RateControlMode": "QVBR",
                                    "SceneChangeDetect": "TRANSITION_DETECTION"
                                }
                            }
                        },
                        "AudioDescriptions": [
                            {
                                "CodecSettings": {
                                    "Codec": "AAC",
                                    "AacSettings": {
                                        "Bitrate": 96000,
                                        "CodingMode": "CODING_MODE_2_0",
                                        "SampleRate": 48000
                                    }
                                }
                            }
                        ],
                        "OutputSettings": {
                            "HlsSettings": {}
                        },
                        "NameModifier": "MSSN-HLS2"
                    }
                ],
                "OutputGroupSettings": {
                    "Type": "HLS_GROUP_SETTINGS",
                    "HlsGroupSettings": {
                        "SegmentLength": 10,
                        "Destination": "s3://simple-elemental-harvest-bucket/transcode/HLS",
                        "DestinationSettings": {
                            "S3Settings": {
                                "StorageClass": "STANDARD"
                            }
                        },
                        "MinSegmentLength": 0
                    }
                }
            },
            {
                "Name": "DASH ISO",
                "Outputs": [
                    {
                        "ContainerSettings": {
                            "Container": "MPD"
                        },
                        "VideoDescription": {
                            "CodecSettings": {
                                "Codec": "H_264",
                                "H264Settings": {
                                    "MaxBitrate": 10000,
                                    "RateControlMode": "QVBR",
                                    "SceneChangeDetect": "TRANSITION_DETECTION"
                                }
                            }
                        },
                        "NameModifier": "_output1"
                    },
                    {
                        "ContainerSettings": {
                            "Container": "MPD"
                        },
                        "AudioDescriptions": [
                            {
                                "AudioSourceName": "Audio Selector 1",
                                "CodecSettings": {
                                    "Codec": "AAC",
                                    "AacSettings": {
                                        "Bitrate": 96000,
                                        "CodingMode": "CODING_MODE_2_0",
                                        "SampleRate": 48000
                                    }
                                }
                            }
                        ],
                        "NameModifier": "_output2"
                    }
                ],
                "OutputGroupSettings": {
                    "Type": "DASH_ISO_GROUP_SETTINGS",
                    "DashIsoGroupSettings": {
                        "SegmentLength": 30,
                        "Destination": "s3://simple-elemental-harvest-bucket/transcode/dash",
                        "DestinationSettings": {
                            "S3Settings": {
                                "StorageClass": "STANDARD"
                            }
                        },
                        "FragmentLength": 2
                    }
                }
            },
            {
                "Name": "MS Smooth",
                "Outputs": [
                    {
                        "ContainerSettings": {
                            "Container": "ISMV"
                        },
                        "VideoDescription": {
                            "CodecSettings": {
                                "Codec": "H_264",
                                "H264Settings": {
                                    "MaxBitrate": 10000,
                                    "RateControlMode": "QVBR",
                                    "SceneChangeDetect": "TRANSITION_DETECTION"
                                }
                            }
                        },
                        "AudioDescriptions": [
                            {
                                "CodecSettings": {
                                    "Codec": "AAC",
                                    "AacSettings": {
                                        "Bitrate": 96000,
                                        "CodingMode": "CODING_MODE_2_0",
                                        "SampleRate": 48000
                                    }
                                }
                            }
                        ],
                        "NameModifier": "MSSN-HLS2"
                    }
                ],
                "OutputGroupSettings": {
                    "Type": "MS_SMOOTH_GROUP_SETTINGS",
                    "MsSmoothGroupSettings": {
                        "Destination": "s3://simple-elemental-harvest-bucket/transcode/smooth",
                        "FragmentLength": 2
                    }
                }
            }
        ],
        "FollowSource": 1,
        "Inputs": [
            {
                "AudioSelectors": {
                    "Audio Selector 1": {
                        "DefaultSelection": "DEFAULT"
                    }
                },
                "VideoSelector": {},
                "TimecodeSource": "ZEROBASED"
            }
        ]
    },
    "BillingTagsSource": "JOB",
    "AccelerationSettings": {
        "Mode": "DISABLED"
    },
    "StatusUpdateInterval": "SECONDS_60",
    "Priority": 0
}
"""


def read_mc_config():
    return json.loads(MC_CONFIG)


def handle_transcode(file_input: str):
    mediaconvert_client = boto3.client("mediaconvert", region="ap-south-1")
    media_convert_template = read_mc_config()
    media_convert_template["Settings"]["Inputs"][0]["FileInput"] = file_input
    response = mediaconvert_client.create_job(**media_convert_template)
    return response["Job"]
