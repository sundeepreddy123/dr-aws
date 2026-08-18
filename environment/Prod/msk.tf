module "msk" {
  source = "../../modules/msk"

  cluster_name = "bank-prod-eu1-msk"

  vpc_id = module.vpc.vpc_id

  msk_subnet_ids = module.vpc.private_subnet_ids

  eks_node_security_group_id = module.eks.node_security_group_id

  kafka_version          = "3.9.x"
  broker_instance_type   = "kafka.m7g.large"
  storage_size           = 100
  log_retention_days     = 30
  enhanced_monitoring   = "PER_BROKER"

  tags = {
    Project     = "bank"
    Environment = "prod"
    Region      = "eu1"
    Component   = "msk"
  }
}