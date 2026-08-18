// Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.identifier}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = module.eks.cluster_security_group_id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow EKS workloads to access PostgreSQL"
}

resource "aws_vpc_security_group_egress_rule" "rds" {
  security_group_id = aws_security_group.rds.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

// DB Subnet Group
resource "aws_db_subnet_group" "this" {

  name = "${var.identifier}-subnet"

  subnet_ids = var.subnet_ids
}
// Primary Database

resource "aws_db_instance" "primary" {

  identifier = var.identifier

  engine = var.engine

  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  db_name = var.db_name

  username = var.username

  password = var.password

  skip_final_snapshot = true

  publicly_accessible = false

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  backup_retention_period = 7

  multi_az = true

  storage_encrypted = true
}