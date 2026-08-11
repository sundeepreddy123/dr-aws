module "eks" {

  source = "../../modules/eks"

  providers = {
    aws = aws.dr
  }

  cluster_name = "dr-eks"

  cluster_version = "1.33"

  vpc_id = module.vpc.vpc_id

  private_subnets = module.vpc.private_subnets

  node_instance_types = [
    "m6i.large"
  ]

  desired_size = 2

  min_size = 2

  max_size = 30


}