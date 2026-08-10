resource "aws_iam_policy" "s3_policy" {

name = "${var.cluster_name}-s3-policy"


policy = jsonencode({

Version = "2012-10-17"

Statement = [

{
Effect = "Allow"

Action = [
"s3:GetObject",
"s3:ListBucket"
]


Resource = [

"arn:aws:s3:::my-app-bucket",

"arn:aws:s3:::my-app-bucket/*"

]

}

]

})

}

resource "aws_iam_role_policy_attachment" "attach" {


role = aws_iam_role.irsa_role.name


policy_arn = aws_iam_policy.s3_policy.arn


}