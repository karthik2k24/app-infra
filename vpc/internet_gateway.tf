resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.pvt_app_vpc.id
  tags = {
    Name = "app-igw"
  }
}
