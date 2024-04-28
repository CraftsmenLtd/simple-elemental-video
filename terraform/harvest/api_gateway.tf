# live
resource "aws_api_gateway_resource" "live_api_resource" {
  rest_api_id = var.api_gw_rest_api_id
  parent_id   = var.api_gw_root_resource_id
  path_part   = "live"
}

# live/manifest
module "api_live_manifest" {
  source = "./../commons/api_gateway"

  api_path = "manifest"
  methods  = ["GET"]

  region        = data.aws_region.current.name
  prefix        = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.live_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}

# live/marker
module "api_live_marker" {
  source = "./../commons/api_gateway"

  api_path = "marker"
  methods  = ["POST"]

  region        = data.aws_region.current.name
  prefix        = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.live_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}

# harvest
resource "aws_api_gateway_resource" "harvest_api_resource" {
  rest_api_id = var.api_gw_rest_api_id
  parent_id   = var.api_gw_root_resource_id
  path_part   = "harvest"
}

# harvest/job
module "api_harvest_job" {
  source = "./../commons/api_gateway"

  api_path = "job"
  methods  = ["POST"]

  region        = data.aws_region.current.name
  prefix        = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.harvest_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}

# harvest/status
module "api_harvest_status" {
  source = "./../commons/api_gateway"

  api_path = "status"
  methods  = ["GET"]

  region        = data.aws_region.current.name
  prefix        = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.harvest_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}

# vod
resource "aws_api_gateway_resource" "vod_api_resource" {
  rest_api_id = var.api_gw_rest_api_id
  parent_id   = var.api_gw_root_resource_id
  path_part   = "vod"
}

# vod/manifest
module "api_vod_manifest" {
  source = "./../commons/api_gateway"

  api_path = "manifest"
  methods  = ["POST"]

  region        = data.aws_region.current.name
  prefix        = var.prefix
  rest_api_id   = var.api_gw_rest_api_id
  parent_api_id = aws_api_gateway_resource.vod_api_resource.id

  api_key_required = false

  enable_lambda_integration = true
  lambda_function_arn       = aws_lambda_function.lambda_functions[local.lambda_options.l2v-harvest.name].arn
}