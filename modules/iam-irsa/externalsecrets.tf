data "aws_iam_policy_document" "external_secrets_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"

      values = [
        "system:serviceaccount:external-secrets:external-secrets-sa"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"

      values = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "external_secrets" {

  name = "${var.cluster_name}-external-secrets"

  assume_role_policy = data.aws_iam_policy_document.external_secrets_assume[0].json

  tags = {
    Name = "${var.cluster_name}-external-secrets"
  }
}
data "aws_iam_policy_document" "external_secrets_policy" {

  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      // "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.secret_prefix}*"
      var.external_secrets_secret_arn
    ]
  }
}

resource "aws_iam_policy" "external_secrets" {

  name   = "${var.cluster_name}-external-secrets"
  policy = data.aws_iam_policy_document.external_secrets_policy[0].json

  tags = {
    Name = "${var.cluster_name}-external-secrets"
  }
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = aws_iam_role.external_secrets[0].name
  policy_arn = aws_iam_policy.external_secrets[0].arn
}