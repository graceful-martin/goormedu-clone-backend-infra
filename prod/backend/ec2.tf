resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQFZ3gpnzHJ9keCj2FbQ/O0dLaBdoPH/yHK2/FqPQjsPaAcMo6FLYsS027Jlsh1nJvOALtULMQ1TojjhaDONHO9QNM5pgC0v1I7/tnnEJZK+nik4kZRzQyHDIlzeyzrlCuFt65FipEGJ2KBx6yLI09v/PfXmknmj9Q7VYjuJf0JJVP6D9xVKoqRGPRP5x2dYlsf2/6MfibJJSgvcpg3z7sHGZ5+ahqV0BsFrVYswOgNxMWPnD+HPaebrRX2DckOZf+xN/5nVCXs4aQBjl7Bf+Bjmp/88Wmrcou5w+vUgi1MCOyhBUwnHOixxQoGt4/lN3kdxBfo1PBmplTUDVDdCw8yDmwVTlzq1c4u8Hf/d7qxUCSWnYI2HQAOcG1Ckfl6kHwwr2F8FxCEx4zsD2C+x+Xm8MyrPZ/QJ1YTlkd7+gWqdCvOikWJCBmX7pl0a4BQS7qpbsiJ9JT8wYluJljdZbCVUfz79H6dkMTM3RA5K9zVRoXE27Z4i8A33IfpFddbndg2ng1Z64Bp4yQ2JhuHfVHX60P93kI+LOM92ujD7ywPzPwZHkkGYR8zjuTMVFM/nksA0qft9J+XRDQXY6q+7Of8FhbWUTx7O+kj30DiXAnHsNFkL93ftXxgS34Ga4Sf3nT2HyNEOyjP1rtaGsOqzLze9WBHHw+4CWyH8vRZso9oQ== cudy_@Heap"
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