# VPC and Network Outputs
output "vpc_id" {
    description = "VPC id"
    value = aws_vpc.main.id
}

output "public_subnet_id" {
    description = "Public subnet id"
    value = aws_subnet.public.id
}

output "private_subnet_a_id" {
    description = "Private subnet A id"
    value = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
    description = "Private subnet B id"
    value = aws_subnet.private_b.id
}

# EC2 Outputs
output "ec2_public_ip" {
    description = "Public IP address of the EC2 instance"
    value = aws_instance.web.public_ip
}

output "ec2_public_dns" {
    description = "Public DNS of the EC2 instance"
    value = aws_instance.web.public_dns
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

# RDS Outputs
output "rds_endpoint" {
    description = "RDS endpoint (address)"
    value = aws_db_instance.mysql.address
    sensitive = true
}

output "rds_port" {
    description = "RDS port"
    value = aws_db_instance.mysql.port
}

output "rds_database_name" {
  description = "Name of the database"
  value       = aws_db_instance.mysql.db_name
}

output "rds_username" {
  description = "RDS instance username"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}

# Security Group Outputs
output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

# Network ACL Output
output "network_acl_id" {
  description = "ID of the Network ACL"
  value       = aws_network_acl.main_acl.id
}

# Application URLs
output "direct_ec2_url" {
  description = "Direct URL to access EC2 instance (for testing)"
  value       = "http://${aws_instance.web.public_ip}"
}

# Database Connection String (for application configuration)
output "database_connection_info" {
  description = "Database connection information"
  value = {
    endpoint = aws_db_instance.mysql.address
    port     = aws_db_instance.mysql.port
    database = aws_db_instance.mysql.db_name
    username = aws_db_instance.mysql.username
  }
  sensitive = true
}