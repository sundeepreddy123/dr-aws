output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "nodegroup_role_arn" {
  value = aws_iam_role.nodegroup.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb.arn
}

output "external_dns_role_arn" {
  value = aws_iam_role.external_dns.arn
}

output "velero_role_arn" {
  value = aws_iam_role.velero.arn
}

output "karpenter_role_arn" {
  value = aws_iam_role.karpenter.arn
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi.arn
}