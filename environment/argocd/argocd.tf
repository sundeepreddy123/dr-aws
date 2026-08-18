module "argocd" {
  source = "../../modules/argocd"

  argocd_chart_version = var.chart_version
}