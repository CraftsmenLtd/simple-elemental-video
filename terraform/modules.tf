module "mediaconnect" {
  source                 = "./mediaconnect"
  prefix                 = var.prefix
  mediaconnect_protocol  = var.mediaconnect_settings.mediaconnect_protocol
  whitelist_cidr_address = var.mediaconnect_settings.whitelist_cidr_address
  ingest_port            = var.mediaconnect_settings.ingest_port
}

module "medialive" {
  source                  = "./medialive"
  prefix                  = var.prefix
  mediaconnect_flow_arn   = module.mediaconnect.flow_arn
  mediapackage_channel_id = module.mediapackage.channel_id
}

module "mediapackage" {
  source = "./mediapackage"
  prefix = var.prefix
}

module "api-gateway" {
  source    = "./commons/api_gateway_base"
  prefix    = var.prefix
  api_stage = var.prefix
}

module "harvest" {
  source                  = "./harvest"
  prefix                  = var.prefix
  api_gw_rest_api_id      = module.api-gateway.api_gw_rest_api_id
  api_gw_root_resource_id = module.api-gateway.api_gw_root_resource_id
  medialive_channel_id    = module.medialive.channel_id
  mediapackage_channel_id = module.mediapackage.channel_id
  mediapackage_hls_endpoint = module.mediapackage.hls_origin_endpoint
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = module.api-gateway.api_gw_rest_api_id
  stage_name  = var.prefix

  depends_on = [module.harvest]

  lifecycle {
    create_before_destroy = true
  }
}