data "aws_iam_policy_document" "lambda_assume_role_policy" {
  version = "2012-10-17"

  statement {
    sid     = "LambdaAssume"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_common_policy" {
  version = "2012-10-17"

  statement {
    sid = "LogPolicy"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "aws_iam_policy_document" "harvest_assume_role_policy" {
  version = "2012-10-17"

  statement {
    sid     = "HarvestAssume"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["mediapackage.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "harvest_policy" {
  version = "2012-10-17"

  statement {
    sid = "HarvestPolicy"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.harvest_bucket.arn
    ]
  }
}

data "aws_iam_policy_document" "harvest_web_player_bucket_policy_for_cloudfront" {
  statement {
    sid = "PublicRead"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.web_player_access.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.harvest_web_player_bucket.arn}/*"
    ]
  }
}
