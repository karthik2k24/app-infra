# EC2 Instance with Bastion Security Group
# resource "aws_instance" "bastion_instance" {
#   ami           = "ami-0ca9fb66e076a6e32"  # Replace with your preferred AMI ID
#   instance_type = "t2.micro"               # Choose your preferred instance type
#   key_name      = "SRE2"                   # Replace with your SSH key pair name
#   subnet_id     = aws_subnet.pub_app_1a.id # Replace with the appropriate public subnet ID

#   security_groups = [aws_security_group.bastion_sg.name]

#   tags = {
#     Name = "Bastion Host"
#   }

#   # Optional: Add user data if you want to run scripts on startup
#   # user_data = <<-EOF
#   #               #!/bin/bash
#   #               echo "Hello, World!" > /var/log/hello.txt
#   #               EOF
# }
