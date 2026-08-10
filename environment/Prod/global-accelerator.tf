module "global_accelerator" {

  source = "../../modules/global-accelerator"

  providers = {
    aws = aws.primary
  }

  accelerator_name = "production-dr"

  primary_region = "ap-south-1"

  dr_region = "ap-south-2"

  production_alb_arn = module.alb_production.alb_arn

  dr_alb_arn = module.alb_dr.alb_arn

}