module "ecr" {
  source       = "../../modules/ecr"
  repositories = var.repositories
}

resource "aws_ecr_replication_configuration" "dr" {

  replication_configuration {

    rule {

      destination {
        region      = var.dr_region
        registry_id = var.dr_account_id
      }
    }
  }
}