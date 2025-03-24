
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

# resource "aws_subnet" "pub_app_1b" {
#   vpc_id                  = aws_vpc.pvt_app_vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name                                    = "pub-app-1b"
#     "kubernetes.io/role/elb"                = "1"     # Required for internet-facing ALB
#     "kubernetes.io/cluster/pvt-app-cluster" = "owned" # Ensures EKS can use it
#   }
# }


# # Public Subnet 1c
# resource "aws_subnet" "pub_app_1c" {
#   vpc_id                  = aws_vpc.pvt_app_vpc.id
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = "us-east-1c"
#   map_public_ip_on_launch = true
#   tags = {
#     Name                                    = "pub-app-1c"
#     "kubernetes.io/role/elb"                = "1"     # Required for internet-facing ALB
#     "kubernetes.io/cluster/pvt-app-cluster" = "owned" # Ensures EKS can use it
#   }
# }