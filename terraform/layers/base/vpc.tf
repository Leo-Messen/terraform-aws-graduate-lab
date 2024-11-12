data "aws_availability_zones" "available_azs" {
  state = "available"
}

locals {
  az_names = slice(data.aws_availability_zones.available_azs.names, 0, 3)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.lab-1-vpc-name
  cidr = var.lab-1-vpc-cidr

  azs             = local.az_names                                                          // all available
  private_subnets = [for k, v in local.az_names : cidrsubnet(var.lab-1-vpc-cidr, 3, k)]     // 1 per AZ
  public_subnets  = [for k, v in local.az_names : cidrsubnet(var.lab-1-vpc-cidr, 3, k + 4)] // 1 per AZ

  enable_nat_gateway     = true
  single_nat_gateway     = var.environment == "dev" ? true : false // true when in dev environment
  one_nat_gateway_per_az = false                                   // 1 subnet in each AZ so no need to specify this
}
