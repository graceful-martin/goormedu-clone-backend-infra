resource "tls_private_key" "private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = "goormedu-clone-keypair"       
  public_key = tls_private_key.private-key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.private-key.private_key_pem}' > ./goormedu-clone-keypair.pem"
  }
}

resource "aws_s3_bucket" "key-bucket" {
  bucket = "goormedu-clone-key-bucket"

  tags = {
    Name        = "goormedu-clone-key-bucket"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.key-bucket.id
  key    = "goormedu-clone-keypair.pem"
  acl    = "private" 
  source = "./goormedu-clone-keypair.pem"
  etag = filemd5("./goormedu-clone-keypair.pem")
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
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