# variables.tf

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "audit_bucket_name" {
  type    = string
  default = "bank-cloudtrail-audit-logs"
}