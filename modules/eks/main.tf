module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  endpoint_public_access = true
  endpoint_private_access = true

  enable_irsa = true

  addons = {
    vpc_cni = {
      most_recent = true

      configuration_values = jsonencode({
        env = {
          "ENABLE_PREFIX_DELEGATION" = "true"
          "WARM_ENI_TARGET"           = "1"
        }
      })
    }

    kube_proxy = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {

    default = {

      instance_types = var.node_instance_types

      desired_size = var.desired_size

      min_size = var.min_size

      max_size = var.max_size

      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "${var.cluster_name}"
    Terraform  = "true"
  }
}

