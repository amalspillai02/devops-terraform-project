# resource "aws_instance" "app_server" {
#   ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
#   instance_type = "t2.micro"
#   subnet_id     = var.public_subnet_id
#   vpc_security_group_ids = [aws_security_group.app_sg.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               amazon-linux-extras install docker -y
#               service docker start
#               usermod -a -G docker ec2-user
#               docker run -d -p 80:80 prakash2405/myapp
#               EOF

#   tags = {
#     Name = "AppServer"
#   }
# }

# resource "aws_security_group" "app_sg" {
#   name        = "allow_http"
#   description = "Allow HTTP inbound traffic"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

