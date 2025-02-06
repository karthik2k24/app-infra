resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS nodes"
  vpc_id      = aws_vpc.pvt_app_vpc.id


  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_sg" {
  name   = "eks-cluster-sg"
  vpc_id = aws_vpc.pvt_app_vpc.id

  # Egress Rule - Allow outbound traffic to anywhere (0.0.0.0/0)
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  # Ingress Rules for internal communication within the VPC
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" # Allow HTTPS communication within VPC
  }

  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # Allow HTTP communication within VPC
  }

  # Ingress for EKS API Server (allow from anywhere)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access to EKS API server
  }

  # Self communication within the security group (for pod-to-pod communication)
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true # Allow internal communication within the security group
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true # Allow UDP internal communication within the security group
  }

  # Allow DNS (53) over both TCP and UDP
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow DNS from anywhere
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Allow DNS over UDP from anywhere
  }
}