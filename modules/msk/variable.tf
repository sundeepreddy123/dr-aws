variable "cluster_name" {
  description = "Name of the MSK cluster."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where MSK will be deployed."
  type        = string
}

variable "msk_subnet_ids" {
  description = "Private subnet IDs for MSK brokers. Use one subnet per AZ."
  type        = list(string)

  validation {
    condition     = length(var.msk_subnet_ids) >= 3
    error_message = "MSK requires at least 3 subnet IDs for this production design."
  }
}

variable "eks_node_security_group_id" {
  description = "Security group ID allowed to connect to MSK."
  type        = string
}

variable "kafka_version" {
  description = "Apache Kafka version supported by MSK."
  type        = string
}

variable "broker_instance_type" {
  description = "MSK broker instance type."
  type        = string
}

variable "storage_size" {
  description = "EBS storage size in GiB per MSK broker."
  type        = number

  validation {
    condition     = var.storage_size >= 100
    error_message = "Use at least 100 GiB per broker for this production baseline."
  }
}

variable "log_retention_days" {
  description = "CloudWatch broker log retention."
  type        = number
  default     = 30
}

variable "enhanced_monitoring" {
  description = "MSK enhanced monitoring level."
  type        = string
  default     = "PER_BROKER"

  validation {
    condition = contains(
      [
        "DEFAULT",
        "PER_BROKER",
        "PER_TOPIC_PER_BROKER",
        "PER_TOPIC_PER_PARTITION"
      ],
      var.enhanced_monitoring
    )

    error_message = "Invalid MSK enhanced monitoring level."
  }
}

variable "tags" {
  description = "Tags applied to MSK resources."
  type        = map(string)
  default     = {}
}