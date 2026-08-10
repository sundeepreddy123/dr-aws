module "rds" {

  source = "../../modules/rds"

  providers = {
    aws = aws.primary
  }

  identifier = "prod-db"

  engine = "postgres"

  engine_version = "16"

  instance_class = "db.r6g.large"

  allocated_storage = 100

  db_name = "ecommerce"

  username = "admin"

  password = password1234

  subnet_ids = module.vpc.database_subnets

  vpc_id = module.vpc.vpc_id
}