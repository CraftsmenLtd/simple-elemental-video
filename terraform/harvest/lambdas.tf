locals {
  lambda_runtime      = "python3.8"
  lambda_artifact_dir = "${path.module}/lambda_zip_dir"
  lambda_options = {
    l2v-harvest = {
      name             = "l2v-harvest"
      policy           = data.aws_iam_policy_document.harvest_lambda_policy
      source_directory = "${path.module}/../../harvest/l2v_harvest"
      handler          = "handler.handler"
      timeout          = 300
      env_variables = {
        harvest_role_arn          = aws_iam_role.harvest_role.arn
        mediapackage_hls_endpoint = var.mediapackage_hls_endpoint
        mediapackage_channel_id   = var.mediapackage_channel_id
        medialive_channel_id      = var.medialive_channel_id
        harvest_bucket_name       = aws_s3_bucket.harvest_bucket.id
        vod_bucket_domain_name    = aws_s3_bucket.harvest_bucket.bucket_domain_name
      }
    }
  }
}

data "archive_file" "lambda_zip_files" {
  for_each    = local.lambda_options
  output_path = "${local.lambda_artifact_dir}/${each.value.name}.zip"
  source_dir  = each.value.source_directory
  excludes    = ["__pycache__", "*.pyc", ".pytest_cache", "coverage-report", "test", ".coverage"]
  type        = "zip"
}

module "lambda_layer" {
  source                 = "./../commons/lambda_python_layer"
  lambda_python_runtime  = local.lambda_runtime
  prefix                 = var.prefix
  requirements_file_path = abspath("${path.module}/../../harvest/requirements.txt")
}

resource "aws_lambda_function" "lambda_functions" {
  for_each         = local.lambda_options
  function_name    = "${var.prefix}-${each.value.name}-lambda"
  filename         = data.archive_file.lambda_zip_files[each.value.name].output_path
  source_code_hash = data.archive_file.lambda_zip_files[each.value.name].output_base64sha256
  handler          = each.value.handler
  role             = aws_iam_role.lambda_roles[each.key].arn
  runtime          = local.lambda_runtime
  timeout          = lookup(each.value, "timeout", 60)
  memory_size      = lookup(each.value, "memory_size", 128)
  architectures    = ["x86_64"]
  layers           = [module.lambda_layer.layer_arn]

  environment {
    variables = lookup(each.value, "env_variables", {})
  }

  lifecycle {
    create_before_destroy = true
  }
}
