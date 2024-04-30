variable "prefix" {
  type        = string
  description = "will be applied where possible"
}

variable "start_over_seconds" {
  type = number
  description = "AWS Mediapackage startover in seconds"
  default = 0
}