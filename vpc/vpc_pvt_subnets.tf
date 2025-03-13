#Private Subnets
resource "aws_subnet" "pvt_app_1b" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name                                    = "pvt-app-1b"
    "kubernetes.io/role/internal-elb"       = "1" # Required for internal ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned"
  }
}

resource "aws_subnet" "pvt_app_1c" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name                                    = "pvt-app-1c"
    "kubernetes.io/role/internal-elb"       = "1" # Required for internal ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned"
  }
}


# Private Route Table for 1b
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1b"
  }
}

# Route for Private Subnets in 1b to access the internet via NAT Gateway
# pvt subnet 1b ---> nat_gw_1a
resource "aws_route" "private_route_1b" {
  route_table_id         = aws_route_table.private_rt_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1a.id
}

# Associate Private Subnet 1b with Route Table 1a
resource "aws_route_table_association" "pvt_app_1b_association" {
  subnet_id      = aws_subnet.pvt_app_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}



# Private Route Table for 1c
resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "private-rt-1c"
  }
}

# Route for Private Subnets in 1c to access the internet via NAT Gateway
#pvt subnet 1c ---> nat_gw_1d
resource "aws_route" "private_route_1c" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw_1d.id
}



# Associate Private Subnet 1c with Route Table 1d
resource "aws_route_table_association" "pvt_app_1c_association" {
  subnet_id      = aws_subnet.pvt_app_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}




