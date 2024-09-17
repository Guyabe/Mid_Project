module "ec2_instance" {
source  = "terraform-aws-modules/ec2-instance/aws"

for_each = toset(["one", "two"])

name = "trading-instance-${each.key}"

instance_type          = var.instance_type
key_name               = module.key_pair.key_pair_name
monitoring             = true
vpc_security_group_ids = [ module.sg.security_group_id ]
subnet_id              = module.vpc.private_subnets[0]
associate_public_ip_address = true // USED FOR TESTING ONLY, DELETE WHEN TESTING IS CONCLUDED

user_data = file("../application/stock-app/userdata.sh")

tags = var.tags
}

output "instance_ids" {
    description = "List of EC2 instance IDs"
    value       = [for instance in module.ec2_instance : instance.id]
  }