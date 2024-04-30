variable "prefix" {
  type        = string
  description = "Resource prefix"
}

variable "api_gw_rest_api_id" {
  type        = string
  description = "API Gateway REST API id"
}

variable "api_gw_root_resource_id" {
  type        = string
  description = "API Gateway REST API Root resource id"
}

variable "mediapackage_hls_endpoint" {
  type        = string
  description = "AWS mediapackage HLS endpoint"
}

variable "mediapackage_channel_id" {
  type        = string
  description = "AWS mediapackage channel ID"
}

variable "medialive_channel_id" {
  type        = string
  description = "AWS Medialive channel ID"
}

variable "api_gateway_invoke_url" {
  type = string
  description = "API Gateway invoke url"
}