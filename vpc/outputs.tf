output "vpc_id" {
  value = aws_vpc.pvt_app_vpc.id
}

output "pvt_app_1b_id" {
  value = aws_subnet.pvt_app_1b.id
}

output "pvt_app_1c_id" {
  value = aws_subnet.pvt_app_1c.id
}