locals {
  lambda_runtime            = "python3.8"
  lambda_artifact_dir       = "${path.module}/lambda_zip_dir"
  lambda_options = {
    l2v-harvest = {
      name     = "l2v-harvest"
      policy   = data.aws_iam_policy_document.lambda_common_policy
      source_directory = "${path.module}/../../harvest/l2v_harvest"
      handler  = "handler.handler"
      env_variables = {
        foo = "bar"
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
  source = "./../commons/lambda_python_layer"
  lambda_python_runtime = local.lambda_runtime
  prefix = var.prefix
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
  kms_key_arn      = aws_kms_key.lambda_env_var_kms.arn
  architectures    = ["arm64"]
  layers           = [module.lambda_layer.layer_arn]

  environment {
    variables = lookup(each.value, "env_variables", {})
  }

  lifecycle {
    create_before_destroy = true
  }
}
