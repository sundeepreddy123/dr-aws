// Security Group for RDS
resource "aws_security_group" "rds" {

  name   = "${var.identifier}-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = 5432

    to_port = 5432

    protocol = "tcp"

    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
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