import boto3

s3_client = boto3.client("s3")


def list_objects(bucket_name, prefix="", suffix=""):
    """
    List all objects (files) in the specified S3 bucket under the given prefix.
    """

    paginator = s3_client.get_paginator("list_objects_v2")
    operation_parameters = {"Bucket": bucket_name, "Prefix": prefix}
    page_iterator = paginator.paginate(**operation_parameters)

    for page in page_iterator:
        if "Contents" in page:
            for obj in page["Contents"]:
                if suffix and obj["Key"].endswith(suffix):
                    yield obj


def get_last_modified_files(bucket_name, prefix="", suffix="", num_files=10):
    """
    Get the last modified files in the specified S3 bucket under the given prefix.
    """
    objects = list(list_objects(bucket_name, prefix, suffix))
    sorted_objects = sorted(objects, key=lambda x: x["LastModified"], reverse=True)[
                     :num_files]

    return sorted_objects
