resource "aws_security_group" "pvt_subnets_sg" {
  name        = "pvt-subnets-sg"
  description = "Security group for EC2 instances in private subnets"
  vpc_id      = aws_vpc.pvt_app_vpc.id

  # Allow SSH access from Bastion Host (you can limit this to specific Bastion host IP if desired)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Allow SSH from Bastion Host
  }

  # Allow traffic to PostgreSQL on port 5432 from EC2 instances in private subnets
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.postgres_sg.id] # Allow traffic from PostgreSQL DB
  }

  # Allow internal communication between EC2 instances in private subnets (optional)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow internal communication between all private EC2 instances
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pvt-subnets-sg"
  }
}
