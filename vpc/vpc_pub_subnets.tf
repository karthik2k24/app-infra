
# Public Subnet
resource "aws_subnet" "pub_app_1a" {
  vpc_id                  = aws_vpc.pvt_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name                                    = "pub-app-1a"
    "kubernetes.io/role/elb"                = "1"     # Required for internet-facing ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned" # Ensures EKS can use it
  }
}

resource "aws_subnet" "pub_app_1d" {
  vpc_id                  = aws_vpc.pvt_app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = true
  tags = {
    Name                                    = "pub-app-1d"
    "kubernetes.io/role/elb"                = "1"     # Required for internet-facing ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned" # Ensures EKS can use it
  }
}

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

resource "aws_route_table_association" "pub_app_1d_association" {
  subnet_id      = aws_subnet.pub_app_1d.id
  route_table_id = aws_route_table.public_rt.id
}






