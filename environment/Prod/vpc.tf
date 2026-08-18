module "vpc" {

  source = "../../modules/vpc"

  providers = {
    aws = aws.primary
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
}

resource "aws_ec2_transit_gateway_vpc_attachment" "prod" {
  transit_gateway_id = data.terraform_remote_state.management.outputs.tgw_id

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnet_ids

  dns_support = "enable"

  tags = {
    Name = "prod-tgw-attachment"
  }
}

resource "aws_route" "prod_to_management" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id = each.value

  destination_cidr_block = "10.0.0.0/16"

  transit_gateway_id = data.terraform_remote_state.management.outputs.tgw_id
}


resource "aws_ec2_transit_gateway_route_table" "argocd_prod" {
  transit_gateway_id = data.terraform_remote_state.management.outputs.tgw_id

  tags = {
    Name = "argocd-prod-tgw-route-table"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "management" {
  transit_gateway_attachment_id = data.terraform_remote_state.management.outputs.tgw_management_attachment_id

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.argocd_prod.id
}

resource "aws_ec2_transit_gateway_route_table_association" "prod" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.prod.id

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.argocd_prod.id
}

resource "aws_ec2_transit_gateway_route" "to_prod" {
  destination_cidr_block = "10.40.0.0/16"

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.argocd_prod.id

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.prod.id
}
resource "aws_ec2_transit_gateway_route" "to_management" {
  destination_cidr_block = "10.0.0.0/16"

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.argocd_prod.id

  transit_gateway_attachment_id = data.terraform_remote_state.management.outputs.tgw_management_attachment_id
}