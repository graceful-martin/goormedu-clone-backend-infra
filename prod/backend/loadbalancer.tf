resource "aws_security_group" "allow_alb" {
  name        = "allow_alb"
  description = "Allow ALB inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_alb"
  }
}

data "aws_subnets" "public-subnets" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-1", "public-subnet-2", "public-subnet-3"]
  }
}

resource "aws_lb_listener" "redirect-listener" {
  load_balancer_arn = aws_lb.goormedu-clone-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "goormedu-clone.com"
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.goormedu-clone-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  name        = "alb-target-group"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_lb" "goormedu-clone-alb" {
  name               = "goormedu-clone-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb.id]
  subnets            = data.aws_subnets.public-subnets.ids

  # enable_deletion_protection = true
  enable_http2 = false

  tags = {
    Environment = "production"
  }
}