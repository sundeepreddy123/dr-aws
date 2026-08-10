resource "aws_iam_role" "aws_load_balancer_controller" {

  name = "${var.cluster_name}-aws-load-balancer-controller"

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

            "${local.oidc_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"

            "${local.oidc_url}:aud" = "sts.amazonaws.com"
          }
        }
      }

    ]
  })

  tags = {
    Name = "${var.cluster_name}-aws-load-balancer-controller"
  }
}

resource "aws_iam_policy" "lb_controller_policy" {

  name = "${var.cluster_name}-AWSLoadBalancerControllerPolicy"

  policy = file(
    "${path.module}/policies/alb-controller-policy.json"
  )
}


resource "aws_iam_role_policy_attachment" "lb_controller" {

  role = aws_iam_role.aws_load_balancer_controller.name

  policy_arn = aws_iam_policy.lb_controller_policy.arn
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {

  metadata {

    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }
  }
}