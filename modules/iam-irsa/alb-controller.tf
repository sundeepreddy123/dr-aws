data "aws_iam_policy_document" "alb_controller_assume" {
  count = var.enable_alb_controller ? 1 : 0

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
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  count = var.enable_alb_controller ? 1 : 0

  name = "${var.cluster_name}-aws-load-balancer-controller"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume[0].json

  tags = {
    Name = "${var.cluster_name}-aws-load-balancer-controller"
  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  count = var.enable_alb_controller ? 1 : 0

  name = "${var.cluster_name}-AWSLoadBalancerControllerPolicy"

  policy = file(
    "modules/iam-irsa/policies/alb-controller-policy.json"
  )
}


resource "aws_iam_role_policy_attachment" "alb_controller" {
  count = var.enable_alb_controller ? 1 : 0

  role = aws_iam_role.aws_load_balancer_controller.name

  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
  