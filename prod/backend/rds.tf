data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["goormedu-clone-vpc"]
  }
}

resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow DB inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "DB from VPC"
    from_port   = 3306
    to_port     = 3306
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
    Name = "allow_db"
  }
}

data "aws_subnets" "private-subnets" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-1", "private-subnet-2", "private-subnet-3"]
  }
}

resource "aws_db_subnet_group" "subnets" {
  name       = "goormedu-clone-db-subnets"
  subnet_ids = data.aws_subnets.private-subnets.ids

  tags = {
    Name = "goormedu-clone-db-subnets"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage     = 30
  max_allocated_storage = 50
  engine                = "mysql"
  engine_version        = "8.0.28"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "ZVHLS3RKaQpkWY74xNVN"
  identifier            = "goormedu-clone-db"
  db_name               = "goormedu"
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.subnets.id
  vpc_security_group_ids = [
    aws_security_group.allow_db.id
  ]
  tags = {
    "Name" = "goormedu-clone-db"
  }
}