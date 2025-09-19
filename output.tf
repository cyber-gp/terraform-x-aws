output "vpc_id" {
    description = "VPC id"
    value = aws_vpc.main.id
}

output "public_subnet_id" {
    description = "Public subnet id"
    value = aws_subnet.public.id
}

output "private_subnet_id" {
    description = "Private subnet id"
    value = aws_subnet.private.id
}

output "ec2_public_ip" {
    description = "Public IP address of the EC2 instance"
    value = aws_instance.web.public_ip
}

output "ec2_public_dns" {
    description = "Public DNS of the EC2 instance"
    value = aws_instance.web.public_dns
}

output "rds_endpoint" {
    description = "RDS endpoint (address)"
    value = aws_db_instance.mysql.address
}

output "rds_port" {
    description = "RDS port"
    value = aws_db_instance.mysql.port
}