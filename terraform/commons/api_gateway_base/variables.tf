variable "prefix" {
  type        = string
  description = "Resource prefix"
}

variable "api_domain" {
  type        = string
  description = "API gateway domain"
  default     = ""
}

variable "api_stage" {
  type        = string
  description = "API stage"
}