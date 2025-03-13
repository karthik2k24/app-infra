# Elastic IP for NAT Gateway in pub_app_1a
resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-1a"
  }
}

 #Elastic IP for NAT Gateway in pub_app_1b
resource "aws_eip" "nat_eip_1b" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-1b"
  }
}

 #Elastic IP for NAT Gateway in pub_app_1c
resource "aws_eip" "nat_eip_1c" {
  domain = "vpc"
  tags = {
    Name = "nat-eip-1c"
  }
}
