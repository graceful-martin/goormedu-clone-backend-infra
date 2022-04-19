############################################################################
# Route Table Association
############################################################################

resource "aws_route_table_association" "route-table-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table-1.id
}

resource "aws_route_table_association" "route-table-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table-2.id
}

resource "aws_route_table_association" "route-table-association-3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.public-route-table-3.id
}

resource "aws_route_table_association" "route-table-association-4" {
  subnet_id      = aws_subnet.private-subnet-4.id
  route_table_id = aws_route_table.private-route-table-1.id
}

resource "aws_route_table_association" "route-table-association-5" {
  subnet_id      = aws_subnet.private-subnet-5.id
  route_table_id = aws_route_table.private-route-table-2.id
}

resource "aws_route_table_association" "route-table-association-6" {
  subnet_id      = aws_subnet.private-subnet-6.id
  route_table_id = aws_route_table.private-route-table-3.id
}