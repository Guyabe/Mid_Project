module "sg" {
    source = "terraform-aws-modules/security-group/aws"

    name                    = var.sg_name
    description             = var.sg_description
    vpc_id                  = module.vpc.vpc_id

    ingress_cidr_blocks      = var.ingress_cidr_blocks
    ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  }