data "aws_subnets" "private-nat-subnets" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-2", "private-subnet-4", "private-subnet-6"]
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
  platform_version     = "1.3.0"
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

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/clusterName/serviceName"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}