module "eks" {

  source = "../../modules/eks"

  providers = {
    aws = aws.prod
  }

  cluster_name = "prod-eks"

  cluster_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  node_instance_types = [
    "m6i.large"
  ]

  desired_size = 10

  min_size = 10

  max_size = 30
}
