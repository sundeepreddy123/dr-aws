resource "helm_release" "argocd" {

  name = "argocd"
  namespace = "argocd"

  repository = "https://argoproj.github.io/argo-helm"

  chart = "argo-cd"

  version = var.chart_version

  create_namespace = true

  values = [

    file("${path.module}/values.yaml")

  ]

  wait = true
  timeout = "900"

}