#Private Subnets
resource "aws_subnet" "pvt_app_1a" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name                                    = "pvt-app-1a"
    "kubernetes.io/role/internal-elb"       = "1" # Required for internal ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned"
  }
}

resource "aws_subnet" "pvt_app_1b" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name                                    = "pvt-app-1b"
    "kubernetes.io/role/internal-elb"       = "1" # Required for internal ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned"
  }
}

resource "aws_subnet" "pvt_app_1c" {
  vpc_id            = aws_vpc.pvt_app_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name                                    = "pvt-app-1c"
    "kubernetes.io/role/internal-elb"       = "1" # Required for internal ALB
    "kubernetes.io/cluster/pvt-app-cluster" = "owned"
  }
}