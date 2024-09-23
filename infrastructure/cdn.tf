module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["placeholder.com"]

  comment             = "CloudFront serving images from S3"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true

  origin_access_identities = {
    s3_bucket_one = "CloudFront OAI for S3 access"
  }

  origin = {
    s3_one = {
      domain_name = "${module.s3_bucket.s3_bucket_bucket_domain_name}.s3.amazonaws.com" 
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"  
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "s3_one"  
    viewer_protocol_policy     = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = false
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"   # Serving static content like images
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = false
    }
  ]

  # Viewer Certificate (SSL)
  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
    ssl_support_method  = "sni-only"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
