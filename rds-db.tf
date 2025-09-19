resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = [aws_subnet.private.id]


    tags = merge(var.tags, { Name = "rds-subnet-group" })
}

resource "aws_db_instance" "mysql" {
    allocated_storage = var.db_allocated_storage
    engine = "mysql"
    engine_version = "8.0"
    instance_class = var.db_instance_class
    username = var.db_username
    password = var.db_password
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true

    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    publicly_accessible = false

    tags = merge(var.tags, { Name = "mysql-db" })
}