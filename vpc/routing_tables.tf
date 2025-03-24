# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "public-rt"
  }
}

# Route for Internet Access
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igw.id
}


# Associate Public Subnet with Route Table
resource "aws_route_table_association" "pub_app_1a_association" {
  subnet_id      = aws_subnet.pub_app_1a.id
  route_table_id = aws_route_table.public_rt.id
}

# resource "aws_route_table_association" "pub_app_1b_association" {
#   subnet_id      = aws_subnet.pub_app_1b.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "pub_app_1c_association" {
#   subnet_id      = aws_subnet.pub_app_1c.id
#   route_table_id = aws_route_table.public_rt.id
# }
# Private Route Table for 1b
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1a"
  }
}

# Route for Private Subnets in 1b to access the internet via NAT Gateway
# pvt subnet 1a ---> nat_gw_1a
resource "aws_route" "private_route_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}

# Associate Private Subnet 1a with Route Table 1a
resource "aws_route_table_association" "pvt_app_1a_association" {
  subnet_id      = aws_subnet.pvt_app_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}



# Private Route Table for 1b
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1b"
  }
}

# Route for Private Subnets in b to access the internet via NAT Gateway
#pvt subnet 1b ---> nat_gw_1b
resource "aws_route" "private_route_1b" {
  route_table_id         = aws_route_table.private_rt_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}



# Associate Private Subnet 1b with Route Table 1b
resource "aws_route_table_association" "pvt_app_1b_association" {
  subnet_id      = aws_subnet.pvt_app_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}



# # Private Route Table for 1c
# resource "aws_route_table" "private_rt_1c" {
#   vpc_id = aws_vpc.pvt_app_vpc.id
#   tags = {
#     Name = "private-rt-1c"
#   }
# }

# # Route for Private Subnets in b to access the internet via NAT Gateway
# #pvt subnet 1c---> nat_gw_1c
# resource "aws_route" "private_route_1c" {
#   route_table_id         = aws_route_table.private_rt_1c.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw_1c.id
# }



# # Associate Private Subnet 1c with Route Table 1c
# resource "aws_route_table_association" "pvt_app_1c_association" {
#   subnet_id      = aws_subnet.pvt_app_1c.id
#   route_table_id = aws_route_table.private_rt_1c.id
# }