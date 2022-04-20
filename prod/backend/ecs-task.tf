variable "aws-env" {}

data "aws_iam_policy_document" "task-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs-task-role" {
  name = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.task-assume-role-policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}

resource "aws_ecs_task_definition" "goormedu-clone-task" {
  family                   = "goormedu-clone-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs-task-role.arn
  task_role_arn            = aws_iam_role.ecs-task-role.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "goormedu-clone-container",
    "image": "${aws_ecr_repository.ecr.repository_url}",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [{
      "containerPort": 4000,
      "hostPort": 4000
    }],
    "secrets": [
        {
          "valueFrom": "${var.aws-env}:AWS_CLIENT_ID::",
          "name": "AWS_CLIENT_ID"
        },
        {
          "valueFrom": "${var.aws-env}:AWS_REGION::",
          "name": "AWS_REGION"
        },
        {
          "valueFrom": "${var.aws-env}:AWS_S3::",
          "name": "AWS_S3"
        },
        {
          "valueFrom": "${var.aws-env}:AWS_SECRET::",
          "name": "AWS_SECRET"
        },
        {
          "valueFrom": "${var.aws-env}:CLIENT_DOMAIN::",
          "name": "CLIENT_DOMAIN"
        },
        {
          "valueFrom": "${var.aws-env}:DB_DATABASE::",
          "name": "DB_DATABASE"
        },
        {
          "valueFrom": "${var.aws-env}:DB_HOST::",
          "name": "DB_HOST"
        },
        {
          "valueFrom": "${var.aws-env}:DB_PASSWORD::",
          "name": "DB_PASSWORD"
        },
        {
          "valueFrom": "${var.aws-env}:DB_PORT::",
          "name": "DB_PORT"
        },
        {
          "valueFrom": "${var.aws-env}:DB_USERNAME::",
          "name": "DB_USERNAME"
        },
        {
          "valueFrom": "${var.aws-env}:DOMAIN::",
          "name": "DOMAIN"
        },
        {
          "valueFrom": "${var.aws-env}:GOOGLE_CLIENT_ID::",
          "name": "GOOGLE_CLIENT_ID"
        },
        {
          "valueFrom": "${var.aws-env}:GOOGLE_SECRET::",
          "name": "GOOGLE_SECRET"
        },
        {
          "valueFrom": "${var.aws-env}:JWT_PRIVATEKEY::",
          "name": "JWT_PRIVATEKEY"
        },
        {
          "valueFrom": "${var.aws-env}:PORT::",
          "name": "PORT"
        },
        {
          "valueFrom": "${var.aws-env}:SENTRY_DSN::",
          "name": "SENTRY_DSN"
        }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
  }
}