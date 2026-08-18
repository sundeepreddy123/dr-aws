# cloudtrail.tf

resource "aws_cloudtrail" "audit" {
  name = "research-center-audit"

  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch.arn

  include_global_service_events = true

  is_multi_region_trail = true

  enable_log_file_validation = true
}

resource "aws_cloudtrail_event_data_store" "s3_audit" {
  name                       = "s3-object-audit"
  multi_region_enabled       = true
  organization_enabled       = false
  retention_period           = 365
  termination_protection_enabled = true

  advanced_event_selector {
    name = "S3 object-level events"

    field_selector {
      field  = "eventCategory"
      equals = ["Data"]
    }

    field_selector {
      field  = "resources.type"
      equals = ["AWS::S3::Object"]
    }

    field_selector {
      field  = "eventName"
      equals = [
        "GetObject",
        "PutObject",
        "DeleteObject"
      ]
    }
  }
}

resource "aws_cloudtrail" "audit" {
  name = "research-center-audit"

  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch.arn

  include_global_service_events = true
  is_multi_region_trail          = true
  enable_log_file_validation     = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"

      values = [
        "${aws_s3_bucket.research.arn}/"
      ]
    }
  }
}