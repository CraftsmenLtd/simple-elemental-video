variable "prefix" {
  type        = string
  description = "will be applied where possible"
}

variable "start_over_seconds" {
  type = number
  description = "AWS Mediapackage startover in seconds"
  default = 0
}

variable "playlist_window_seconds" {
  type = number
  description = "AWS Mediapackage playlist window in seconds"
  default = 60
}