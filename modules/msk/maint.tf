resource "aws_security_group" "msk" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for Amazon MSK"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

# EKS -> MSK
# IAM authenticated MSK listener uses TCP 9098.

resource "aws_vpc_security_group_ingress_rule" "msk_from_eks" {
  security_group_id            = aws_security_group.msk.id
  referenced_security_group_id = module.eks.cluster_security_group_id

  from_port   = 9098
  to_port     = 9098
  ip_protocol = "tcp"
}
# MSK outbound
resource "aws_vpc_security_group_egress_rule" "msk_all" {
  security_group_id = aws_security_group.msk.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

/// KMS encryption

resource "aws_kms_key" "msk" {
  description         = "KMS key for ${var.cluster_name} MSK"
  enable_key_rotation = true

  tags  =  {
    Name = "${var.cluster_name}-kms"
  }
}

resource "aws_kms_alias" "msk" {
  name          = "alias/${var.cluster_name}"
  target_key_id = aws_kms_key.msk.key_id
}

# ---------------------------------------------------------
# CloudWatch Log Group
# ---------------------------------------------------------

resource "aws_cloudwatch_log_group" "msk" {
  name              = "/aws/msk/${var.cluster_name}"
  retention_in_days = var.log_retention_days

  tags = {
      Name = "/aws/msk/${var.cluster_name}"   
}
}

# ---------------------------------------------------------
# Amazon MSK
# ---------------------------------------------------------

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = var.broker_instance_type

    client_subnets = var.msk_subnet_ids

    security_groups = [
      aws_security_group.msk.id
    ]

    storage_info {
      ebs_storage_info {
        volume_size = var.storage_size
      }
    }
  }

  # -------------------------------------------------------
  # IAM Authentication
  # -------------------------------------------------------

  client_authentication {
    sasl {
      iam = true
    }
  }

  # -------------------------------------------------------
  # Encryption
  # -------------------------------------------------------

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.msk.arn

    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  # -------------------------------------------------------
  # Monitoring
  # -------------------------------------------------------

  enhanced_monitoring = var.enhanced_monitoring

  # -------------------------------------------------------
  # Broker Logs
  # -------------------------------------------------------

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    aws_cloudwatch_log_group.msk,
    aws_kms_alias.msk
  ]
}

resource "aws_msk_configuration" "configuration" {
    name          = "${var.cluster_name}-configuration"
    kafka_versions = [var.kafka_version]

    server_properties = <<EQF
auto.create.topics.enable = true
delete.topic.enable = true
default.replication.factor = 3
min.insync.replicas = 2
num.partitions = 6
EQF
}