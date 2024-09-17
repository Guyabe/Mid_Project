####################
##### VPC ##########
####################

variable "name" {
    description = "The name of the VPC"
    type        = string
    default = "trading-vpc"
  }

  variable "cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default = "10.0.0.0/16"
  }

  variable "azs" {
    description = "The list of availability zones"
    type        = list(string)
    default     = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
  }

  variable "private_subnets" {
    description = "The list of private subnets"
    type        = list(string)
    default     = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
  }

  variable "public_subnets" {
    description = "The list of public subnets"
    type        = list(string)
    default     = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]
  }

  variable "enable_nat_gateway" {
    description = "Enable NAT Gateway"
    type        = bool
    default = true
  }

  variable "enable_vpn_gateway" {
    description = "Enable VPN Gateway"
    type        = bool
    default = false
  }

  variable "single_nat_gateway" {
    description = "Single NAT Gateway"
    type        = bool
    default = true
  }

  variable "enable_dns_hostnames" {
    description = "Enable DNS HOSTNAME"
    type        = bool
    default = true
  }

  variable "enable_dns_support" {
    description = "Enable DNS Support"
    type        = bool
    default = true
  }

  variable "tags" {
    description = "Tags to associate with the VPC"
    type        = map(string)
    default = {}
  }

  ####################
  ##### KEYPAIRS #####
  ####################

  variable "key_name" {
    description = "Input desired keypair name"
    type        = string
    default = "trading-key"
  }
  variable "create_private_key" {
    description = "Create a private key"
    type        = bool
    default = true
  }

  ####################
  ##### EC2 ##########
  ####################

  variable "instance_name_one" {
    description = "Desired first instance name"
    type = string
    default = "trading-instance-1"
  }

  variable "instance_type" {
    description = "Desired instance type"
    type = string
    default = "t2.micro"
  }

  variable "instance_ami" {
    description = "AMI to use for the instance"
    type = string
    default = "ami-0ebfd941bbafe70c6"
  }

  ####################
  ######### SG #######
  ####################

  variable "sg_name" {
    description = "The name of the security group"
    type        = string
    default = "trading-sg"
  }

  variable "sg_description" {
    description = "Description for the SG"
    type        = string
    default = "Security group for the trading app instances"
  }

  variable "ingress_cidr_blocks" {
    description = "List of IPv4 CIDR ranges to use on all ingress rules"
    type        = list(string)
    default     = ["10.0.0.0/16"]
  }

  variable "ingress_with_cidr_blocks" {
    description = "List of computed ingress rules to create where 'cidr_blocks' is used"
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      cidr_blocks = string
    }))
    default = [
      {
        from_port   = 5001
        to_port     = 5001
        protocol    = "tcp"
        description = "Custom port 5001"
        cidr_blocks = "10.0.0.0/16"
      },
      {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        description = "Custom port 8000"
        cidr_blocks = "10.0.0.0/16"
      }
    ]
  }

