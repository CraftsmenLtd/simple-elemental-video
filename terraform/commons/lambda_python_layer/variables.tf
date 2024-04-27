variable "prefix" {
  type        = string
  description = "Resource prefix"
}

variable "lambda_python_runtime" {
  type        = string
  description = "Lambda python runtime"
}

variable "requirements_file_path" {
  type        = string
  description = "Python requirements file path"
}