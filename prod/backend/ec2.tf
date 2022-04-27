resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = "goormedu-clone-keypair"       
  public_key = tls_private_key.private-key.public_key_openssh
}

resource "aws_s3_bucket" "key-bucket" {
  bucket = "goormedu-clone-key-bucket"

  tags = {
    Name = "goormedu-clone-key-bucket"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.key-bucket.id
  key    = "goormedu-clone-keypair.pem"
  acl    = "private" 
  content = tls_private_key.private-key.private_key_pem
}

data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
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
    from_port   = 22
    to_port     = 22
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
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.key-pair.key_name

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