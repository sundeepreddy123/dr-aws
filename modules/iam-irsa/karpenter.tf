resource "aws_iam_role" "karpenter_controller" {

  name = "${var.cluster_name}-karpenter-controller"

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

            "${local.oidc_url}:sub" = "system:serviceaccount:karpenter:karpenter"

            "${local.oidc_url}:aud" = "sts.amazonaws.com"
          }
        }
      }

    ]
  })
}

resource "aws_iam_role" "karpenter_node" {

  name = "${var.cluster_name}-karpenter-node"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })
}
resource "aws_iam_role_policy_attachment" "karpenter_node_worker" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "karpenter_node_ecr" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}