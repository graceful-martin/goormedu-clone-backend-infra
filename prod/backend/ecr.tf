resource "aws_ecr_repository" "ecr" {
  name                 = "goormedu-clone-repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}