  module "ec2_instance" {
      source  = "terraform-aws-modules/ec2-instance/aws"

      for_each = toset(["one", "two"])

      name = "trading-instance-${each.key}"

      instance_type          = var.instance_type
      key_name               = module.key_pair.key_pair_name
      monitoring             = true
      vpc_security_group_ids = [ module.sg.security_group_id ]
      subnet_id              = module.vpc.private_subnets[0]
      associate_public_ip_address = true

      user_data = file("../application/stock-app/userdata.sh")

      tags = var.tags
    }