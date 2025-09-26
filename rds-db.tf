resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = merge(var.tags, { Name = "rds-subnet-group" })
}

resource "aws_db_instance" "mysql" {
  allocated_storage           = var.db_allocated_storage
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = var.db_instance_class
  identifier                 = "mysql-db-instance"
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  parameter_group_name       = "default.mysql8.0"
  skip_final_snapshot        = true
  final_snapshot_identifier  = null
  
  # Multi-AZ deployment for high availability
  multi_az = var.db_multi_az
  
  # Backup configuration
  backup_retention_period = var.db_backup_retention_period
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # Storage encryption
  storage_encrypted = true
  
  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  
  # Performance insights
  performance_insights_enabled = true
  performance_insights_retention_period = 7

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  # Deletion protection for production
  deletion_protection = var.db_deletion_protection

  tags = merge(var.tags, { Name = "mysql-db" })
}

# IAM role for RDS monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
