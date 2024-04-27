resource "aws_s3_bucket" "harvest_bucket" {
  bucket = "${var.prefix}-harvest-bucket"
}