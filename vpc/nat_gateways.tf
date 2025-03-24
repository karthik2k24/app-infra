# NAT Gateway in pub_app_1a
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.pub_app_1a.id
  tags = {
    Name = "nat-gateway-1a"
  }
}

# # NAT Gateway in pub_app_1b
# resource "aws_nat_gateway" "nat_gw_1b" {
#   allocation_id = aws_eip.nat_eip_1b.id
#   subnet_id     = aws_subnet.pub_app_1b.id
#   tags = {
#     Name = "nat-gateway-1b"
#   }
# }

# # NAT Gateway in pub_app_1c
# resource "aws_nat_gateway" "nat_gw_1c" {
#   allocation_id = aws_eip.nat_eip_1c.id
#   subnet_id     = aws_subnet.pub_app_1c.id
#   tags = {
#     Name = "nat-gateway-1c"
#   }
# }