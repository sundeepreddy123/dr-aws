resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.chart_version

  create_namespace = true

  set = {
    name  = "clusterName"
    value = var.cluster_name
  }

  set = {
    name  = "region"
    value = var.aws_region
  }

  set = {
    name  = "vpcId"
    value = var.vpc_id
  }

  set = {
    name  = "serviceAccount.create"
    value = "false"
  }

  set = {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [
    var.iam_role_dependency
  ]
}

