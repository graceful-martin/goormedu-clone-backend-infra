resource "aws_ecs_cluster" "cluster" {
  name = "goormedu-clone-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}