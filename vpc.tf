# VPC
resource "aws_vpc" "pvt_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "pvt-app-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "pub_app_1a" {
  vpc_id                  = aws_vpc.pvt_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-app-1a"
  }
}

# Private Subnets
resource "aws_subnet" "pvt_app_1a" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "pvt-app-1a"
  }
}

resource "aws_subnet" "pvt_app_1b" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "pvt-app-1b"
  }
}

resource "aws_subnet" "pvt_app_1c" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "pvt-app-1c"
  }
}


resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "app-igw"
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

