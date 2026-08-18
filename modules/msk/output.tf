output "cluster_arn" {
  description = "ARN of the MSK cluster."
  value       = aws_msk_cluster.this.arn
}

output "cluster_name" {
  description = "Name of the MSK cluster."
  value       = aws_msk_cluster.this.cluster_name
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster."
  value       = aws_msk_cluster.this.cluster_uuid
}

output "bootstrap_brokers_sasl_iam" {
  description = "MSK bootstrap brokers using SASL IAM over TLS."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "msk_security_group_id" {
  description = "Security group ID attached to MSK brokers."
  value       = aws_security_group.msk.id
}

output "kms_key_arn" {
  description = "KMS key ARN used for MSK encryption."
  value       = aws_kms_key.msk.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group for MSK broker logs."
  value       = aws_cloudwatch_log_group.msk.name
}