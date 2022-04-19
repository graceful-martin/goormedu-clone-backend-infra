############################################################################
# Internet Gateway
############################################################################

resource "aws_internet_gateway" "internet-gateway" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "internet-gateway" }
}

############################################################################
# NAT Gateway
############################################################################

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public-subnet-2.id

  tags = {
    Name = "nat-gateway"
  }
}