from dataclasses import dataclass
from datetime import datetime
from uuid import UUID


@dataclass
class S3Destination:
    bucket_name: str
    manifest_key: str
    role_arn: str


@dataclass
class HarvestJob:
    job_id: UUID
    origin_endpoint_id: str
    start_time: datetime
    end_time: datetime
    s3_destination: S3Destination


@dataclass
class ScteMarker:
    scte_marker_id: str
    ad_duration_in_sec: int
