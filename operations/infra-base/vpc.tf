locals {
  vpc_name = "demovpc"

  cidr = "20.10.0.0/16"
  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets_cidrs     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets_cidrs      = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
}

data "aws_security_group" "sg_default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = local.vpc_name

  azs                 = local.azs
  cidr = local.cidr
  private_subnets     = local.private_subnets_cidrs
  public_subnets      = local.public_subnets_cidrs

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_classiclink             = false
  enable_classiclink_dns_support = true

  enable_nat_gateway = true
  enable_dhcp_options              = true
  enable_s3_endpoint = true

  tags = {
    Environment = var.environment
    Name        = local.vpc_name
  }

  public_subnet_tags = {
    Environment = var.environment
    Name        = "${local.vpc_name}-public-subnet"
    Tier = "Public"
  }

  private_subnet_tags = {
    Environment = var.environment
    Name        = "${local.vpc_name}-private-subnet"
    Tier = "Private"
  }
}
