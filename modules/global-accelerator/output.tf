output "accelerator_arn" {

  value = aws_globalaccelerator_accelerator.this.id

}

output "dns_name" {

  value = aws_globalaccelerator_accelerator.this.dns_name

}