resource "aws_cloudwatch_log_group" "apigateway_logs" {
  name = "${var.prefix}-apigateway-logs"
}