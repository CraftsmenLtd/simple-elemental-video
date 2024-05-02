output "api_gw_rest_api_id" {
  description = "API gateway REST API id"
  value       = aws_api_gateway_rest_api.rest_api.id
}

output "api_gw_root_resource_id" {
  description = "API Gateway root resource ID"
  value       = aws_api_gateway_rest_api.rest_api.root_resource_id
}

output "api_gateway_stage" {
  value = var.api_stage
}