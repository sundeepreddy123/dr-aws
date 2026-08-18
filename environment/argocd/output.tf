output "alb_controller_role_arn" {
  value = var.enable_alb_controller ? aws_iam_role.aws_load_balancer_controller[0].arn : null
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "tgw_subnet_ids" {
  value = module.vpc.tgw_subnet_ids
}

output "nat_public_ips" {
  value = module.management_vpc.nat_public_ips
}