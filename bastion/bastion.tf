#EC2 Instance with Bastion Security Group
resource "aws_instance" "bastion_instance" {
  ami                    = "ami-0226f5d1e7c6fc56e"
  instance_type          = "t2.micro"               # Choose your preferred instance type
  key_name               = "SRE2"                   # Replace with your SSH key pair name
  subnet_id              = var.pub_app_1a_id # Replace with the appropriate public subnet ID 
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion Host"
  }
}
