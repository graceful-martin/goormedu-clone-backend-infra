resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDK0y6m5B6m6yhQqK3/i2eCa0t1u76JFyG91aBcCAF/JEnervtwWcMdbCTawOzQA+v1y4FKMgAXh9Kp5dHJL7aV2kIacy2gz5wN/KFgikrYz9lgq4I4zkruRXz4JcJhh+ZYM/CO4c1gh3Ve6jy8QVI8to02aWm2uLdyDMVKu3vB9VELtHkcfr4M/yX/+Ca7Hlegk6gB+2bWuljUCGPhKYUoOH+BSCOKf5p/TEyo2TEYidIWeMKE2npDAkDXfTPSVe4TBm3gKV5TPVO6cOSrSuyiIaOFL3oqbq7coqLmWGDvGznfF92Mx5aTRjU7ABD5egVAzyvWFSTwze+HwtVvQhIDyUobtj6PWy/OiKOab+qzCGb7ZiDdJDPQZ6o9ZPZxb57VfAQ39JUmYIndsE9Mk1H7kSq+pMeg/3kuBpdkkRVrS9JrmwKVF69wsfm0vL2KiNLeYJDCVs2sLOWOYdcT0ZGFYcVqAm06lZIgyoY0ao63Iu4v0ppLdmvurQnzo21mel8= cudy_@Heap"
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]  
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Canonical
}

data "aws_subnet" "public-subnet" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-1"]
  }
}

resource "aws_security_group" "allow_ec2" {
  name        = "allow_ec2"
  description = "Allow EC2 inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 3389
    to_port     = 3389
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
    Name = "allow_ec2"
  }
}

resource "aws_network_interface" "network_interface" {
  subnet_id       = data.aws_subnet.public-subnet.id
  security_groups = [aws_security_group.allow_ec2.id]
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.windows.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.deployer.key_name

  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index         = 0
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = "goormedu-clone-instance"
  }
}