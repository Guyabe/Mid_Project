module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name               = var.name

    cidr               = var.cidr
    azs                = var.azs

    private_subnets    = var.private_subnets
    public_subnets     = var.public_subnets

    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_nat_gateway = var.enable_nat_gateway
    enable_vpn_gateway = var.enable_vpn_gateway
    single_nat_gateway = var.single_nat_gateway

    tags = var.tags
  }


module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id

  endpoints = {
    s3 = {
      # interface endpoint
      vpc_endpoint_type   = "Gateway"
      service             = "s3"
      tags                = { Name = "s3-vpc-endpoint" }
      route_table_ids     = module.vpc.private_route_table_ids
    }
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
