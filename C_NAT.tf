# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_app_1a.id # Ensure this is in the public subnet

  tags = {
    Name = "nat-gateway"
  }
}
# Route for Private Subnets to access the internet via NAT Gateway
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.pvt_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}






resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "pvt-rt"
  }
}


# Associate private subnets with private route table
resource "aws_route_table_association" "pvt_app_1a_association" {
  subnet_id      = aws_subnet.pvt_app_1a.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "pvt_app_1b_association" {
  subnet_id      = aws_subnet.pvt_app_1b.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "pvt_app_1c_association" {
  subnet_id      = aws_subnet.pvt_app_1c.id
  route_table_id = aws_route_table.pvt_rt.id
}



