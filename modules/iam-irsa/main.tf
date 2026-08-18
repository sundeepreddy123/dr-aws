data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {

  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name = "${var.cluster_name}-oidc"
  }
}

locals {

  oidc_url = replace(
    aws_iam_openid_connect_provider.eks.url,
    "https://",
    ""
  )

  oidc_arn = aws_iam_openid_connect_provider.eks.arn
}

resource "aws_iam_role" "nodegroup" {

  name = "${var.cluster_name}-nodegroup-role"

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

resource "aws_iam_role_policy_attachment" "worker" {

  role = aws_iam_role.nodegroup.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "cni" {

  role = aws_iam_role.nodegroup.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_iam_role_policy_attachment" "ecr" {

  role = aws_iam_role.nodegroup.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.nodegroup.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}


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

            "${local.oidc_url}:sub" = "system:serviceaccount:kube-system:karpenter"

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

resource "aws_iam_role_policy_attachment" "karpenter_node_ssm" {

  role = aws_iam_role.karpenter_node.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
