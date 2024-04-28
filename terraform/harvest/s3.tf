resource "aws_s3_bucket" "harvest_bucket" {
  bucket = "${var.prefix}-harvest-bucket"
}

resource "aws_s3_bucket_public_access_block" "web_player_public_access" {
  bucket = aws_s3_bucket.harvest_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.harvest_bucket.id
  policy = data.aws_iam_policy_document.harvest_bucket_policy_for_cloudfront.json
}
