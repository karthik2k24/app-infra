# VPC
resource "aws_vpc" "pvt_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "pvt-app-vpc"
  }
}

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "app-igw"
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

# NAT Gateway in pub_app_1d
resource "aws_nat_gateway" "nat_gw_1d" {
  allocation_id = aws_eip.nat_eip_1d.id
  subnet_id     = aws_subnet.pub_app_1d.id
  tags = {
    Name = "nat-gateway-1d"
  }
}

# Elastic IP for NAT Gateway in pub_app_1d
resource "aws_eip" "nat_eip_1d" {  
  domain = "vpc"
  tags = {
    Name = "nat-eip-1d"
  }
}

# Elastic IP for NAT Gateway in pub_app_1a
resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-1a"
  }
}
