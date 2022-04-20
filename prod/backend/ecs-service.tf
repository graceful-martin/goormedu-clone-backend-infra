data "aws_subnets" "private-nat-subnets" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-4", "private-subnet-5", "private-subnet-6"]
  }
}

resource "aws_security_group" "allow_ecs" {
  name        = "allow_ecs"
  description = "Allow ECS inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "ECS from VPC"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ecs"
  }
}

resource "aws_ecs_service" "goormedu-clone-service" {
  name                 = "goormedu-clone-service"
  launch_type          = "FARGATE"
  force_new_deployment = true
  cluster              = aws_ecs_cluster.cluster.id
  task_definition      = aws_ecs_task_definition.goormedu-clone-task.arn
  desired_count        = 1
  # iam_role        = aws_iam_role.ecs-task-role.arn
  # depends_on      = [aws_iam_role_policy]

  network_configuration {
    subnets         = data.aws_subnets.private-nat-subnets.ids
    security_groups = [aws_security_group.allow_ecs.id]
    # assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-target-group.arn
    container_name   = "goormedu-clone-container"
    container_port   = 4000
  }
}