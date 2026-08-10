output "db_instance_identifier" {
  value = aws_db_instance.primary.identifier
}

output "endpoint" {
  value = aws_db_instance.primary.endpoint
}