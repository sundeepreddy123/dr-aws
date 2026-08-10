###############################################################
# Local Values
###############################################################

locals {

  log_destination = (
    var.log_destination_type == "cloud-watch-logs"
    ? aws_cloudwatch_log_group.this[0].arn
    : aws_s3_bucket.flowlogs[0].arn
  )

  iam_role_arn = (
    var.create_iam_role
    ? aws_iam_role.this.arn
    : var.iam_role_arn
  )

}

###############################################################
# VPC Flow Logs
###############################################################

resource "aws_flow_log" "this" {

  vpc_id = var.vpc_id

  traffic_type = var.traffic_type

  log_destination_type = var.log_destination_type

  log_destination = local.log_destination

  iam_role_arn = (
    var.log_destination_type == "cloud-watch-logs"
    ? local.iam_role_arn
    : null
  )

  max_aggregation_interval = var.max_aggregation_interval

  log_format = join(" ", [

    "$${version}",

    "$${account-id}",

    "$${interface-id}",

    "$${srcaddr}",

    "$${dstaddr}",

    "$${srcport}",

    "$${dstport}",

    "$${protocol}",

    "$${packets}",

    "$${bytes}",

    "$${start}",

    "$${end}",

    "$${action}",

    "$${tcp-flags}",

    "$${log-status}",

    "$${vpc-id}",

    "$${subnet-id}",

    "$${instance-id}",

    "$${pkt-srcaddr}",

    "$${pkt-dstaddr}",

    "$${region}",

    "$${az-id}",

    "$${flow-direction}",

    "$${traffic-path}"

  ])

  tags = merge(

    {

      Name = "${var.name}-flowlogs"

      Environment = var.name

      Terraform = "true"

      Service = "network-observability"

    },

    var.tags

  )

}