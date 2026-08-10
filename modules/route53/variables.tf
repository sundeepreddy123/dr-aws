variable "hosted_zone_id" {
  type = string
}

variable "records" {
  type = map(object({
    name        = string
    type        = string
    ttl         = optional(number)
    records     = optional(list(string))
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  }))
}