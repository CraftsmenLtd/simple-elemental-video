import json


def create_response(status_code: int, body: dict) -> dict:
    """Create an API Gateway response.

    Parameters:
    - status_code (int): The HTTP status code.
    - body (dict): The response body.

    Returns:
    - dict: The API Gateway response.
    """
    return {
        "statusCode": status_code,
        "body": json.dumps(body, indent=4, default=str)
    }
