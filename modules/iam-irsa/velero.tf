resource "aws_iam_role" "velero" {

  name = "${var.cluster_name}-velero"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {

          StringEquals = {

            "${local.oidc_url}:sub" = "system:serviceaccount:velero:velero"

            "${local.oidc_url}:aud" = "sts.amazonaws.com"
          }
        }
      }

    ]
  })
}