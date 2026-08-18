module "tgw" {
  source = "../../modules/tgw"

  name        = "banking-argocd-prod-tgw"
  description = "Private connectivity between ArgoCD management VPC and PROD VPC"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "management" {
  transit_gateway_id = module.tgw.transit_gateway_id

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnet_ids

  dns_support = "enable"

  tags = {
    Name = "management-tgw-attachment"
  }
}

resource "aws_route" "management_to_prod" {
  for_each = toset(module.vpc.private_route_table_ids)

  route_table_id = each.value

  destination_cidr_block = "10.40.0.0/16"

  transit_gateway_id = module.tgw.transit_gateway_id
}