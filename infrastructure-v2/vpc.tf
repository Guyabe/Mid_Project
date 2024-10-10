module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true
  enable_dns_support = true 
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name = "${local.tags.Environment}" })
  
  vpc_tags = {
  Name = "trading-vpc"
}

public_subnet_tags = {
    Name = "${var.vpc_name}-public-subnet"
  }

  private_subnet_tags = {
    Name = "${var.vpc_name}-private-subnet"
  }

  public_route_table_tags = {
    Name = "trading-public-rt"
  }

  private_route_table_tags = {
    Name = "trading-private-rt"
  }

  nat_gateway_tags = {
    Name = "trading-NAT"
  }

  igw_tags = {
    Name = "trading-IGW"
  }
}
