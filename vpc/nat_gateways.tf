# NAT Gateway in pub_app_1a
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.pub_app_1a.id
  tags = {
    Name = "nat-gateway-1a"
  }
}

# NAT Gateway in pub_app_1d
resource "aws_nat_gateway" "nat_gw_1d" {
  allocation_id = aws_eip.nat_eip_1d.id
  subnet_id     = aws_subnet.pub_app_1d.id
  tags = {
    Name = "nat-gateway-1d"
  }
}
