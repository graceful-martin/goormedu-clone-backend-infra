############################################################################
# Public Route Table
############################################################################

resource "aws_route_table" "public-route-table-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }
  tags = { Name = "public-route-table-1" }
}

resource "aws_route_table" "public-route-table-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }
  tags = { Name = "public-route-table-2" }
}

resource "aws_route_table" "public-route-table-3" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }
  tags = { Name = "public-route-table-3" }
}


############################################################################
# Private Route Table
############################################################################

resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
  tags = { Name = "private-route-table-1" }
}

resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
  tags = { Name = "private-route-table-2" }
}

resource "aws_route_table" "private-route-table-3" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
  tags = { Name = "private-route-table-3" }
}