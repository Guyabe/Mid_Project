resource "aws_cloudfront_distribution" "example" {
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  # Communicate with ALB over HTTP
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled      = true
  comment              = "CDN for trading-alb with HTTP"
  default_root_object  = "/"

  # Default Cache Behavior
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"  # Allow both HTTP and HTTPS requests from end-users

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Additional Cache Behaviors for each path pattern from ALB
  ordered_cache_behavior {
    path_pattern           = "/ui/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/metrics/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/mongo-express/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/promtail/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/loki/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/prometheus/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/grafana/*"
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "allow-all"
    cached_methods = ["GET", "HEAD"]
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # CloudFront SSL setup (even though ALB uses HTTP)
  viewer_certificate {
    cloudfront_default_certificate = true  # Use default CloudFront certificate (supports HTTPS)
  }
}
