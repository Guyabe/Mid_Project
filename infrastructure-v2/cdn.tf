resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb_origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_cache_behavior {
    target_origin_id = "alb_origin"
    viewer_protocol_policy = "allow-all"
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-cloudfront-distribution" })
}
