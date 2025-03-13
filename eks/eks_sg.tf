resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS nodes"
  vpc_id     = var.vpc_id

  // Ingress Rules
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  // Egress Rules
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Tags
  tags = {
    Name = "eks-node-sg"
  }
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_sg" {
  name   = "eks-cluster-sg"
  vpc_id = var.vpc_id

  // Egress Rule - Allow outbound traffic to anywhere (0.0.0.0/0)
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  // Ingress Rules for internal communication within the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" # Allow HTTPS communication within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # Allow HTTP communication within VPC
    cidr_blocks = ["10.0.0.0/16"]
  }

  // Ingress for EKS API Server (restrict to specific IP range if possible)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access to EKS API server
  }

  // Self communication within the security group (for pod-to-pod communication)
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

  // Allow DNS (53) over both TCP and UDP
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

  // Tags
  tags = {
    Name = "eks-cluster-sg"
  }
}
