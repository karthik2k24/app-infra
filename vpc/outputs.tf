output "vpc_id" {
  value = aws_vpc.pvt_app_vpc.id
}

output "pvt_app_1a_id" {
  value = aws_subnet.pvt_app_1a.id
}

# output "pvt_app_1b_id" {
#   value = aws_subnet.pvt_app_1b.id
# }

output "pub_app_1a_id" {
  value = aws_subnet.pub_app_1a.id
}