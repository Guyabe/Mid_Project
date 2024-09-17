module "alb" {
    source = "terraform-aws-modules/alb/aws"

    name    = "my-alb"
    vpc_id  = module.vpc.vpc_id
    subnets = module.vpc.public_subnets

    # Security Group
    security_group_ingress_rules = {
      all_http = {
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        description = "HTTP web traffic"
        cidr_ipv4   = "0.0.0.0/0"
      }
      all_https = {
        from_port   = 443
        to_port     = 443
        ip_protocol = "tcp"
        description = "HTTPS web traffic"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
    security_group_egress_rules = {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = "10.0.0.0/16"
      }
    }

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