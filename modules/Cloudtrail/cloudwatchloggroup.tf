# cloudwatch.tf

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/audit"
  retention_in_days = 90
}