
# ---------------------------------------------------------
# Production AWS Provider
# ---------------------------------------------------------

provider "aws" {

  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Project     = "EKS-prod"
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