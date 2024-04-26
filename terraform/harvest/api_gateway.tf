# l2v
resource "aws_api_gateway_resource" "l2v_api_resource" {
  rest_api_id = var.api_gw_rest_api_id
  parent_id   = var.api_gw_root_resource_id
  path_part   = "l2v"
}

# l2v/live/manifest
module "api_live_manifest" {
  source = "./../commons/api_gateway"

  api_path = "live"
  methods  = ["POST"]

  region        = data.aws_region.current.name
  environment   = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.l2v_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}
