variable "name" {
    description = "The name of the VPC"
    type        = string
  }

  variable "cidr" {
    description = "The CIDR block for the VPC"
    type        = string
  }

  variable "azs" {
    description = "The list of availability zones"
    type        = list(string)
  }

  variable "private_subnets" {
    description = "The list of private subnets"
    type        = list(string)
  }

  variable "public_subnets" {
    description = "The list of public subnets"
    type        = list(string)
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
