module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "ai-trading-bucket-technion"
  acl    = "private"

  versioning = {
    enabled = true
  }

 policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${module.cdn.cloudfront_origin_access_identities.s3_bucket_one.id}"}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::ai-trading-bucket-technion/*"
    }
  ]
}
POLICY 
}
