resource "aws_iam_role" "external_secrets" {

  name = "${var.cluster_name}-external-secrets"

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

            "${local.oidc_url}:sub" = "system:serviceaccount:external-secrets:external-secrets"

            "${local.oidc_url}:aud" = "sts.amazonaws.com"
          }
        }
      }

    ]
  })
}
resource "aws_iam_policy" "external_secrets" {

  name = "${var.cluster_name}-external-secrets"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]

        Resource = "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:*"
      }

    ]
  })
}
resource "aws_iam_role_policy_attachment" "external_secrets" {

  role = aws_iam_role.external_secrets.name

  policy_arn = aws_iam_policy.external_secrets.arn
}