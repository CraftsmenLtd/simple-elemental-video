resource "aws_kms_key" "lambda_env_var_kms" {
  description         = "KMS key for lambda environment variables"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.lambda_kms_policy.json

  lifecycle {
    create_before_destroy = true
  }
}
