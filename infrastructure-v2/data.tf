data "aws_ami" "aws_latest" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
}
  filter {
    name  = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}
