# Elastic IP for NAT Gateway in pub_app_1a
resource "aws_eip" "nat_eip_1a" {
  vpc = true
  tags = {
    Name = "nat-eip-1a"
  }
}

# NAT Gateway in pub_app_1a
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.pub_app_1a.id
  tags = {
    Name = "nat-gateway-1a"
  }
}

# Elastic IP for NAT Gateway in pub_app_1d
resource "aws_eip" "nat_eip_1d" {
  vpc = true
  tags = {
    Name = "nat-eip-1d"
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

# Private Route Table for 1a
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1a"
  }
}

# Route for Private Subnets in 1a to access the internet via NAT Gateway
resource "aws_route" "private_route_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}

# Private Route Table for 1d
resource "aws_route_table" "private_rt_1d" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1d"
  }
}

# Route for Private Subnets in 1d to access the internet via NAT Gateway
resource "aws_route" "private_route_1d" {
  route_table_id         = aws_route_table.private_rt_1d.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1d.id
}

# Associate Private Subnet 1b with Route Table 1a
resource "aws_route_table_association" "pvt_app_1b_association" {
  subnet_id      = aws_subnet.pvt_app_1b.id
  route_table_id = aws_route_table.private_rt_1a.id
}

# Associate Private Subnet 1c with Route Table 1d
resource "aws_route_table_association" "pvt_app_1c_association" {
  subnet_id      = aws_subnet.pvt_app_1c.id
  route_table_id = aws_route_table.private_rt_1d.id
}