module "harvest_api" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "1.8.0"

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.apigateway_logs.arn
  create_default_stage                     = false
  description                              = "Harvest API"
  name                                     = "${var.prefix}-http-api"
  protocol_type                            = "HTTP"

  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  cors_configuration = {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }

  integrations = {
    "GET /live/manifest" = {
      lambda_arn             = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "POST /live/marker" = {
      lambda_arn             = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "GET /harvest/job" = {
      lambda_arn             = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    # Harvest job will return it's status and VOD manifest URL
    "GET /harvest/job/{jobid}" = {
      lambda_arn             = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  depends_on = aws_lambda_function.lambda_functions
}

resource "aws_lambda_permission" "vod_qc_api_health_lambda_execution_permission" {
  for_each = aws_lambda_function.lambda_functions
  statement_id  = "AllowAPIGW-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.harvest_api.apigatewayv2_api_execution_arn}/*/*"
}
