locals {
  lambda_artifact_dir       = "${path.module}/lambda_python_layer_dir"
  lambda_layer_zipfile_name = "lambda_python_layer_file"
  lambda_layer_zip_path = "${local.lambda_artifact_dir}/${local.lambda_layer_zipfile_name}.zip"
}

resource "null_resource" "build_lambda_layer" {
  provisioner "local-exec" {
    when    = create
    command = "${path.module}/build_layer.sh"

    environment = {
      ARTIFACT_DIR = abspath(local.lambda_artifact_dir)
      REQUIREMENTS_PATH   = var.requirements_file_path
      ZIPFILE_NAME = local.lambda_layer_zipfile_name
    }
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename            = local.lambda_layer_zip_path
  source_code_hash    = "filebase64sha256(${local.lambda_layer_zip_path})"
  layer_name          = "${var.prefix}-lambda-layer"
  compatible_runtimes = [var.lambda_python_runtime]
  depends_on          = [null_resource.build_lambda_layer]

  lifecycle {
    create_before_destroy = true
  }
}
