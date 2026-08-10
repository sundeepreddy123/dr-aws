resource "aws_ecr_registry_policy" "replication" {

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Sid = "AllowProductionReplication"

        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::${var.production_account_id}:root"
        }

        Action = [
          "ecr:ReplicateImage",
          "ecr:CreateRepository"
        ]
      }
    ]
  })
}