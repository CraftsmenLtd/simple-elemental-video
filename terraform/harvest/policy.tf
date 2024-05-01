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
    sid     = "LogPolicy"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "medialive:BatchUpdateSchedule"
    ]

    resources = [
      "arn:aws:logs:*:*:*",
      "arn:aws:medialive:*:*:channel:*"
    ]
  }
}

data "aws_iam_policy_document" "harvest_lambda_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.lambda_common_policy.json
  ]

  statement {
    sid     = "HarvestLambdaPolicy"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.harvest_bucket.arn,
      "${aws_s3_bucket.harvest_bucket.arn}/*"
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

data "aws_iam_policy_document" "harvest_job_policy" {
  version = "2012-10-17"

  statement {
    sid     = "HarvestPolicy"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketRequestPayment",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.harvest_bucket.arn,
      "${aws_s3_bucket.harvest_bucket.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "harvest_bucket_policy" {
  version = "2012-10-17"

  statement {
    sid = "PublicRead"
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.harvest_bucket.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "harvest_web_player_bucket_cloudfront_policy" {
  statement {
    sid = "PublicRead"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.web_player_access.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]
    effect    = "Allow"
    resources = [
      "${aws_s3_bucket.harvest_web_player_bucket.arn}/*"
    ]
  }
}
