output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "default_route_table_id" {
  value = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "vpc_attachment_ids" {
  value = {
    for k, v in aws_ec2_transit_gateway_vpc_attachment.attachments :
    k => v.id
  }
}