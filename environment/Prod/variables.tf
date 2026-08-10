variable "production_account_id" {
  type = string
}

variable "repositories" {
  type = list(string)
}

variable "dr_region" {
  type = string
}

variable "dr_account_id" {
  type = string
}

variable "dr_alb_arn" {
  type = string
}

variable "production_alb_arn" {
  type = string
}