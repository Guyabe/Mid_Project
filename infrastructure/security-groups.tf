module "sg" {
    source = "terraform-aws-modules/security-group/aws"

    name                    = var.sg_name
    description             = var.sg_description
    vpc_id                  = module.vpc.vpc_id

    ingress_cidr_blocks      = var.ingress_cidr_blocks
    ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  }


  module "alb_sg" {
      source  = "terraform-aws-modules/security-group/aws"

      name   = "alb-sg"
      description = "ALB Security Group"
      vpc_id = module.vpc.vpc_id

      ingress_with_cidr_blocks = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "Allow HTTP"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "Allow HTTPS"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]

      egress_with_cidr_blocks = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          description = "Allow all outbound traffic"
          cidr_blocks = ["10.0.0.0/16"]
        },
      ]
    }
