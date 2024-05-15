resource "aws_cloudfront_origin_access_identity" "web_player_access" {
  comment = "Access for web player client"
}

resource "aws_cloudfront_distribution" "web_player" {
  default_root_object = "index.html"
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
    target_origin_id       = aws_s3_bucket.harvest_web_player_bucket.bucket_regional_domain_name
    viewer_protocol_policy = "allow-all"
  }

  origin {
    domain_name = aws_s3_bucket.harvest_web_player_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.harvest_web_player_bucket.bucket_regional_domain_name
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
    cloudfront_default_certificate = true
  }

  depends_on = [
    aws_s3_bucket.harvest_web_player_bucket
  ]
}

resource "null_resource" "run_web_player_build_script" {
  provisioner "local-exec" {
    command = "harvest/web-player/build_web_player.sh"
    environment = {
      harvest_api_url = module.harvest_api.apigatewayv2_api_api_endpoint
    }
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync harvest/web-player/build s3://${aws_s3_bucket.harvest_web_player_bucket.id}/ --delete"
  }

  depends_on = [
    null_resource.run_web_player_build_script
  ]

  triggers = {
    always_run = timestamp()
  }
}
