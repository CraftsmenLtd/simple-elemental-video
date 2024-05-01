resource "aws_s3_bucket" "harvest_bucket" {
  bucket = "${var.prefix}-harvest-bucket"
}

resource "aws_s3_bucket_policy" "harvest_bucket_policy" {
  bucket = aws_s3_bucket.harvest_bucket.id
  policy = data.aws_iam_policy_document.harvest_bucket_policy.json
}

resource "aws_s3_bucket" "harvest_web_player_bucket" {
  bucket = "${var.prefix}-harvest-web-player-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "web_player_public_access" {
  bucket = aws_s3_bucket.harvest_web_player_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "harvest_web_player_bucket_policy" {
  bucket = aws_s3_bucket.harvest_web_player_bucket.id
  policy = data.aws_iam_policy_document.harvest_web_player_bucket_cloudfront_policy.json
}