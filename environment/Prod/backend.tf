terraform {
  backend "s3" {
    bucket = "banking-platform-terraform-state-CHANGE-ME"

    key    = "prod/terraform.tfstate"

    region = "eu-west-1"

    encrypt      = true
    use_lockfile = true
  }
}