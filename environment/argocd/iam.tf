module "iam_irsa" {
  source = "../../modules/iam-irsa"

  cluster_name = module.eks.cluster_name

  enable_alb_controller = true

  enable_ebs_csi          = false
  enable_external_dns     = false
  enable_external_secrets = false
  enable_karpenter        = false
  enable_velero            = false

  tags = var.common_tags
}