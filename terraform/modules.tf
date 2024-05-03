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
  source                  = "./mediapackage"
  prefix                  = var.prefix
  start_over_seconds      = 3600
  playlist_window_seconds = 300
}

module "harvest" {
  source                    = "./harvest"
  prefix                    = var.prefix
  medialive_channel_id      = module.medialive.channel_id
  mediapackage_channel_id   = module.mediapackage.channel_id
  mediapackage_channel_arn  = module.mediapackage.channel_arn
  mediapackage_hls_endpoint = module.mediapackage.hls_origin_endpoint
}