from pydantic import BaseModel, UUID4, Field
from datetime import datetime


class S3Destination(BaseModel):
    bucket_name: str = Field(..., alias="bucketName")
    manifest_key: str = Field(..., alias="manifestKey")
    role_arn: str = Field(..., alias="roleArn")


class HarvestJob(BaseModel):
    job_id: UUID4 = Field(..., alias="jobId")
    origin_endpoint_id: str = Field(..., alias="originEndpointId")
    start_time: datetime = Field(..., example="2024-04-27T00:00:00Z", alias="startTime")
    end_time: datetime = Field(..., example="2024-04-28T00:00:00Z", alias="endTime")
    s3_destination: S3Destination = Field(..., alias="s3Destination")

    class Config:
        allow_population_by_field_name = True


class ScteMarker(BaseModel):
    scte_marker_id: UUID4 = Field(..., alias="scteMarkerId")
    ad_duration_in_sec: int = Field(..., alias="adDurationInSec")
