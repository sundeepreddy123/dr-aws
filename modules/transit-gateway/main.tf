resource "aws_ec2_transit_gateway" "main" {

  description = var.name

  amazon_side_asn = var.amazon_side_asn

  auto_accept_shared_attachments = "enable"

  default_route_table_association = "enable"

  default_route_table_propagation = "enable"

  dns_support = "enable"

  vpn_ecmp_support = "enable"

  tags = {
    Name = var.name
  }
}
resource "aws_ec2_transit_gateway_vpc_attachment" "attachments" {

  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.main.id

  vpc_id = each.value.vpc_id

  subnet_ids = each.value.subnet_ids

  dns_support = "enable"

  ipv6_support = "disable"

  tags = {
    Name = each.key
  }
}

resource "aws_ec2_transit_gateway_route" "routes" {

  for_each = var.vpc_attachments

  destination_cidr_block = each.value.cidr_block

  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.attachments[each.key].id
}