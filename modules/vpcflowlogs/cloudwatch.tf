###############################################################
# CloudWatch Log Group
###############################################################

locals {

  log_group_name = (
    var.log_group_name != ""
    ? var.log_group_name
    : "/aws/vpc/${var.name}/flowlogs"
  )

}

resource "aws_cloudwatch_log_group" "this" {

  count = var.create_cloudwatch_log_group ? 1 : 0

  name = local.log_group_name

  retention_in_days = var.log_retention_days

  kms_key_id = var.kms_key_id

  tags = merge(
    {
      Name        = "${var.name}-flowlogs"
      Environment = var.name
      Terraform   = "true"
      Service     = "network-observability"
    },
    var.tags
  )

}