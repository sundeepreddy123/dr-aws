data "terraform_remote_state" "prod" {
  backend = "s3"

  config = {
    bucket = "your-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    bucket = "your-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "eu-east-1"
  }
}

data "terraform_remote_state" "dr" {
  backend = "s3"

  config = {
    bucket = "your-terraform-state"

    key = "dr/terraform.tfstate"

    region = "us-east-1"
  }
}