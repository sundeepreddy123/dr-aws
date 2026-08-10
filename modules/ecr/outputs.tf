output "repositories" {
  value = keys(aws_ecr_repository.repos)
}