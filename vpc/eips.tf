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
