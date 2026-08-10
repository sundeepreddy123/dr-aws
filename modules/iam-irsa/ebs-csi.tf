resource "aws_iam_role" "ebs_csi" {

  name = "${var.cluster_name}-ebs-csi"

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

            "${local.oidc_url}:sub" = "system:serviceaccount:ebs-csi:ebs-csi"

            "${local.oidc_url}:aud" = "sts.amazonaws.com"
          }
        }
      }

    ]
  })
}
resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicyV2"
}
resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.eks.name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi
  ]
}

# apiVersion: storage.k8s.io/v1
# kind: StorageClass

# metadata:
#   name: gp3

# provisioner: ebs.csi.aws.com

# volumeBindingMode: WaitForFirstConsumer this is very important to add

# allowVolumeExpansion: true

# reclaimPolicy: Retain

# parameters:
#   type: gp3
#   encrypted: "true"