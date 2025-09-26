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
    
  # Associate public IP explicitly
  associate_public_ip_address = true

  tags = merge(var.tags, { Name = "web-server" })

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system and install Apache
              apt-get update -y
              apt-get upgrade -y
              apt-get install -y apache2 ufw mysql-client-core-8.0

              # Configure Apache
              systemctl start apache2
              systemctl enable apache2

              # Add simple landing page with server info
              cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Bank Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .info { background-color: #ecf0f1; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to the Bank Web Server</h1>
        <div class="info">
            <p><strong>Server Status:</strong> Online</p>
            <p><strong>Environment:</strong> Development</p>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
        </div>
        <p>This server is part of a secure banking infrastructure with:</p>
        <ul>
            <li>Web Application Firewall (WAF) protection</li>
            <li>CloudFront CDN for global content delivery</li>
            <li>Cognito for user authentication</li>
            <li>RDS MySQL database in private subnets</li>
        </ul>
    </div>
</body>
</html>
HTML

              # Basic firewall with UFW (allow SSH & HTTP, deny everything else)
              ufw allow OpenSSH
              ufw allow 'Apache Full'
              ufw --force enable

              # Create a non-root user for admin tasks
              useradd -m -s /bin/bash devops
              echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
              
              # Add SSH key for devops user (copy from ubuntu user)
              mkdir -p /home/devops/.ssh
              cp /home/ubuntu/.ssh/authorized_keys /home/devops/.ssh/authorized_keys
              chown -R devops:devops /home/devops/.ssh
              chmod 700 /home/devops/.ssh
              chmod 600 /home/devops/.ssh/authorized_keys

              # Restart Apache to ensure it's running
              systemctl restart apache2
EOF

  # Ensure the instance is created after the internet gateway route
  depends_on = [aws_route.public_internet_access]
}
