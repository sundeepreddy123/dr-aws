
data "aws_iam_policy_document" "eks_node_assume" {

  statement {

    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {

      type        = "Service"

      identifiers = ["ec2.amazonaws.com"]

    }

  }

}

resource "aws_iam_role" "node" {

  name               = "${var.cluster_name}-eks-nodegroup"

  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json

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