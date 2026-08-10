###############################################################
# IAM Assume Role Policy
###############################################################

data "aws_iam_policy_document" "flowlogs_assume_role" {

  statement {

    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "vpc-flow-logs.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

###############################################################
# IAM Role
###############################################################

resource "aws_iam_role" "this" {

  name = "${var.name}-vpc-flowlogs-role"

  assume_role_policy = data.aws_iam_policy_document.flowlogs_assume_role.json

  tags = merge(
    {
      Name        = "${var.name}-flowlogs-role"
      Environment = var.name
      Terraform   = "true"
      Service     = "network-observability"
    },
    var.tags
  )
}

###############################################################
# CloudWatch Policy
###############################################################

data "aws_iam_policy_document" "flowlogs_policy" {

  statement {

    sid = "CloudWatchLogs"

    effect = "Allow"

    actions = [

      "logs:CreateLogGroup",

      "logs:CreateLogStream",

      "logs:DescribeLogGroups",

      "logs:DescribeLogStreams",

      "logs:PutLogEvents"

    ]

    resources = [
      "${aws_cloudwatch_log_group.this[0].arn}:*",
      aws_cloudwatch_log_group.this[0].arn
    ]
  }

}

###############################################################
# IAM Policy
###############################################################

resource "aws_iam_policy" "this" {

  name = "${var.name}-vpc-flowlogs-policy"

  description = "IAM policy for VPC Flow Logs"

  policy = data.aws_iam_policy_document.flowlogs_policy.json

  tags = merge(
    {
      Name = "${var.name}-flowlogs-policy"
    },
    var.tags
  )
}

###############################################################
# Attach Policy
###############################################################

resource "aws_iam_role_policy_attachment" "this" {

  role = aws_iam_role.this.name

  policy_arn = aws_iam_policy.this.arn

}