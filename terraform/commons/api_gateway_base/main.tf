resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.prefix}-api"
  description = "Elemental API"
  binary_media_types = [
    "application/binary",
    "application/bxf+xml",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name = "${var.prefix}-api-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api.id
    stage  = var.api_stage
  }
}


resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch_role.arn
}

resource "aws_api_gateway_method_settings" "api_gw_settings" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = var.api_stage
  method_path = "*/*"

  settings {
    caching_enabled      = true
    metrics_enabled      = false
    logging_level        = "INFO"
    cache_data_encrypted = true
    data_trace_enabled   = false
  }
}

resource "aws_api_gateway_domain_name" "api_gw_domain_name" {
  count = var.api_domain == "" ? 0 : 1
  domain_name     = var.api_domain
}

resource "aws_api_gateway_base_path_mapping" "api_mapping" {
  count = var.api_domain == "" ? 0 : 1
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = var.api_stage
  domain_name = aws_api_gateway_domain_name.api_gw_domain_name[0].domain_name
  base_path   = ""
}
