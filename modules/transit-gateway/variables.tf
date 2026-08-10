variable "name" {
  type = string
}

variable "amazon_side_asn" {
  type    = number
  default = 64512
}

variable "vpc_attachments" {
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
    cidr_block = string
  }))
}