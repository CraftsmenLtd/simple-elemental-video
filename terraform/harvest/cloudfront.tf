resource "aws_cloudfront_origin_access_identity" "web_player_access" {
  comment = "Access for web player client"
}

resource "aws_cloudfront_distribution" "web_player" {
  default_root_object = "web-player/index.html"
  enabled             = true
  price_class         = "PriceClass_All"
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.harvest_bucket.bucket_regional_domain_name
    viewer_protocol_policy = "allow-all"
  }

  origin {
    domain_name = aws_s3_bucket.harvest_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.harvest_bucket.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.web_player_access.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_s3_object" "upload_web_player_dict" {
  for_each = fileset("../../harvest/web-player/build/", "*")

  bucket = aws_s3_bucket.harvest_bucket.id
  key    = each.value
  source = "../../harvest/web-player/build/${each.value}"

  depends_on = [
    null_resource.run_build_script
  ]
}

resource "null_resource" "run_build_script" {
  provisioner "local-exec" {
    command = "../../harvest/web-player/build_web_player.sh"
    environment = {
      module_path = path.module,
    }
  }

  triggers = {
    always_run = timestamp()
  }
}
