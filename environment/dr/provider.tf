provider "aws" {

  region = "ap-south-2"

  assume_role {
    role_arn = "arn:aws:iam::$2222222222222222222:role/terraform"
  }

  default_tags {
    tags = {
      Environment = "Disaster-Recovery"
      ManagedBy   = "Terraform"
      Project     = "EKS-DR"
    }
  }
}
provider "kubernetes" {

  host = module.eks.cluster_endpoint

  cluster_ca_certificate = base64decode(
    module.eks.cluster_certificate_authority_data
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"

    command = "aws"

    args = [
      "eks",
      "get-token",
      "--region",
      "ap-south-1",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}
provider "helm" {

  kubernetes = {

    host = module.eks.cluster_endpoint

    cluster_ca_certificate = base64decode(
      module.eks.cluster_certificate_authority_data
    )

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--region",
        "ap-south-1",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}