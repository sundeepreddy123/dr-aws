module "vpc" {

  source = "../../modules/vpc"

  providers = {
    aws = aws.argocd
  }

  name = "prod-vpc"

  vpc_cidr = "10.0.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]

  database_subnets = [
    "10.0.21.0/24",
    "10.0.22.0/24",
    "10.0.23.0/24"
  ]

  enable_nat_gateway = true
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_ec2_transit_gateway_vpc_attachment" "management" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  vpc_id = module.management_vpc.vpc_id

  subnet_ids = module.management_vpc.private_subnet_ids

  tags = {
    Name = "management-tgw-attachment"
  }
}