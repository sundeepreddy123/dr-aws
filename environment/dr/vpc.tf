module "vpc" {

  source = "../../modules/vpc"

  providers = {
    aws = aws.dr
  }

  name = "dr-vpc"

  vpc_cidr = "10.1.0.0/16"

  azs = [
    "ap-south-2a",
    "ap-south-2b",
    "ap-south-2c"
  ]

  public_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]

  private_subnets = [
    "10.1.11.0/24",
    "10.1.12.0/24",
    "10.1.13.0/24"
  ]

  database_subnets = [
    "10.1.21.0/24",
    "10.1.22.0/24",
    "10.1.23.0/24"
  ]
}