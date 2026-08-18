variable "chart_version" {
  type        = string
  description = "ArgoCD Helm chart version"
}
variable "enable_alb_controller" {
  type        = bool
  description = "Enable ALB controller"
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

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}