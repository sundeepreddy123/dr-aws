data "aws_eks_cluster" "management" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "management" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.management.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.management.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.management.token
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "dr"
  region = "us-east-1"
}