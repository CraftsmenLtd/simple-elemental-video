resource "aws_iam_role" "api_gw_cloudwatch_role" {
  name               = "${var.prefix}-api-gw-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.api_gw_policy.json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "api_gw_policy_attachment" {
  role       = aws_iam_role.api_gw_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}