module "iam" {

  source = "../../modules/iam"

  cluster_name      = module.eks.cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

}