resource "aws_ecr_repository" "repos" {

  for_each = toset(var.repositories)

  name = each.value

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}
//Lifecycle Policy : Keep only the latest 30 images

resource "aws_ecr_lifecycle_policy" "frontend" {

  repository = aws_ecr_repository.repos[each.key].name

  policy = jsonencode({

    rules = [

      {
        rulePriority = 1

        description = "Keep last 30 images"

        selection = {

          tagStatus = "any"

          countType = "imageCountMoreThan"

          countNumber = 30

        }

        action = {

          type = "expire"

        }

      }

    ]

  })
} 
