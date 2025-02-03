#EC2 Instance with Bastion Security Group
resource "aws_instance" "bastion_instance" {
  ami                    = "ami-01493046d3cff1aba"
  instance_type          = "t2.micro"               # Choose your preferred instance type
  key_name               = "SRE2"                   # Replace with your SSH key pair name
  subnet_id              = aws_subnet.pub_app_1a.id # Replace with the appropriate public subnet ID 
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion Host"
  }
}
