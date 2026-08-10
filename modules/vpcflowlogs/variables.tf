#############################################
# General
#############################################

variable "name" {
  description = "Environment name (dev, test, prod, management)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

#############################################
# Flow Logs
#############################################

variable "traffic_type" {
  description = "Traffic type to capture"
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.traffic_type)
    error_message = "traffic_type must be ACCEPT, REJECT or ALL."
  }
}

variable "max_aggregation_interval" {
  description = "Aggregation interval"
  type        = number
  default     = 60

  validation {
    condition     = contains([60, 600], var.max_aggregation_interval)
    error_message = "Aggregation interval must be 60 or 600."
  }
}

#############################################
# CloudWatch
#############################################

variable "create_cloudwatch_log_group" {
  type    = bool
  default = true
}

variable "log_group_name" {
  type    = string
  default = ""
}

variable "log_retention_days" {
  type    = number
  default = 30
}

#############################################
# S3
#############################################

variable "create_s3_bucket" {
  type    = bool
  default = true
}

variable "s3_bucket_name" {
  type    = string
  default = ""
}

variable "enable_bucket_versioning" {
  type    = bool
  default = true
}

variable "enable_bucket_encryption" {
  type    = bool
  default = true
}

variable "s3_transition_days" {
  type    = number
  default = 30
}

variable "s3_glacier_days" {
  type    = number
  default = 90
}

variable "s3_expiration_days" {
  type    = number
  default = 365
}

#############################################
# Firehose
#############################################

variable "enable_firehose" {
  type    = bool
  default = false
}

#############################################
# Athena
#############################################

variable "enable_athena" {
  type    = bool
  default = false
}

variable "athena_database_name" {
  type    = string
  default = "vpc_flow_logs"
}

#############################################
# CloudWatch Alarm
#############################################

variable "enable_alarm" {
  type    = bool
  default = true
}

variable "alarm_threshold" {
  type    = number
  default = 100
}

variable "sns_topic_arn" {
  type    = string
  default = null
}

#############################################
# KMS
#############################################

variable "kms_key_id" {
  type    = string
  default = null
}

###############################################################
# Destination
###############################################################

variable "log_destination_type" {

  description = "cloud-watch-logs or s3"

  type = string

  default = "cloud-watch-logs"

  validation {

    condition = contains(

      [

        "cloud-watch-logs",

        "s3"

      ],

      var.log_destination_type

    )

    error_message = "Destination must be cloud-watch-logs or s3."

  }

}

###############################################################
# Existing IAM Role
###############################################################

variable "create_iam_role" {

  type = bool

  default = true

}

variable "iam_role_arn" {

  type = string

  default = null

}