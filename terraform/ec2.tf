resource "aws_instance" "web" {
  ami                    = "ami-03cf5768bcc686a8c"
  instance_type          = "t3.micro"
  key_name               = "cohort8-key"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  tags = {
    Name = "devops-capstone-server"
  }
}

output "ec2_public_ip" {
  description = "Public IP address of the DevOps capstone EC2 instance"
  value       = aws_instance.web.public_ip
}
