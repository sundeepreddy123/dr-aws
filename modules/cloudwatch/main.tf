resource "aws_cloudwatch_metric_alarm" "alb_5xx" {

  alarm_name          = "prod-alb-5xx"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 3

  metric_name         = "HTTPCode_Target_5XX_Count"

  namespace           = "AWS/ApplicationELB"

  period              = 60

  statistic           = "Sum"

  threshold           = 10

  alarm_description   = "ALB returning too many 5xx errors"

  dimensions = {
    LoadBalancer = var.alb_name
  }

  alarm_actions = [
    var.sns_topic_arn
  ]
}

# Meaning: If:

# 5xx errors > 10
# for 3 minutes

resource "aws_sns_topic" "dr" {

  name = "dr-automation"

}