output "bootstrap_brokers_sasl_iam" {
  value = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "client_role_arn" {
  value = aws_iam_role.msk_client.arn
}

output "alb_arn" {
  value = module.eks.alb_arn
}

output "alb_arn" {
  value = module.eks.alb_arn
}