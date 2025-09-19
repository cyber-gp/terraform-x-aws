# Get a recent Ubuntu AMI (Focal 20.04 LTS). This uses Canonical owner id.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# EC2 Instance in the public subnet
resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    
  tags = merge(var.tags, { Name = "web-server" })
    
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Welcome to the Web Server</h1>" > /var/www/html/index.html
              EOF
  }

