module "alb" {
    source = "terraform-aws-modules/alb/aws"

    name    = "my-alb"
    vpc_id  = module.vpc.vpc_id
    subnets = module.vpc.public_subnets

    # Security Group
    security_groups = [module.alb_sg.security_group_id]

    access_logs = {
      bucket = "ai-trading-terraform-state-bucket"
    }

    listeners = {
      ex-http-https-redirect = {
        port     = 80
        protocol = "HTTP"
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
      ex-https = {
        port            = 443
        protocol        = "HTTPS"
        certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

        forward = {
          target_group_key = "ex-instance"
        }
      }
    }

    target_groups = {
      ex-instance = {
        name_prefix      = "h1"
        protocol         = "HTTP"
        port             = 80
        target_type      = "instance"
        target_id        = module.ec2_instance["one"].id
      }
    }

    tags = {
      Environment = "Development"
      Project     = "Example"
    }
  }