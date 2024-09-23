module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "ai-trading-bucket-technion"
  acl    = "private"

  versioning = {
    enabled = true
  }
}
