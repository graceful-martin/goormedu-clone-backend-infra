resource "aws_security_group" "allow_endpoint" {
  name        = "allow_endpoint"
  description = "Allow EndPoint inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "EndPoint from VPC"
    from_port   = 0
    to_port     = 0
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
    Name = "allow_endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_endpoint.id,
  ]

  subnet_ids = data.aws_subnets.private-nat-subnets.subnet_ids

  private_dns_enabled = true
}