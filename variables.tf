# Basic AWS Configuration
variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project - used for resource naming"
  type        = string
  default     = "bank-app"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 KeyPair name for SSH access"
  type        = string
  default     = "geepee-aws-key-pair"
}

# RDS Configuration
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "bankdb"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "db_deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

# Monitoring and Logging
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for EC2 instance"
  type        = bool
  default     = true
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

# SSL/TLS Configuration
variable "create_ssl_certificate" {
  description = "Create SSL certificate for custom domain"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name for the application"
  type        = string
  default     = ""
}

variable "alternative_domain_names" {
  description = "Alternative domain names for the SSL certificate"
  type        = list(string)
  default     = []
}

# Environment and Tagging
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Owner       = "terraform"
    Environment = "dev"
    Project     = "bank-app"
    ManagedBy   = "terraform"
  }
}

# Backup and Recovery
variable "enable_automated_backups" {
  description = "Enable automated backups for critical resources"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 30
}

# Security Configuration
variable "enable_encryption" {
  description = "Enable encryption for storage and data in transit"
  type        = bool
  default     = true
}

variable "enable_access_logging" {
  description = "Enable access logging for load balancers and CloudFront"
  type        = bool
  default     = true
}

# Cost Optimization
variable "enable_spot_instances" {
  description = "Use spot instances for non-critical workloads"
  type        = bool
  default     = false
}

variable "auto_scaling_enabled" {
  description = "Enable auto scaling for EC2 instances"
  type        = bool
  default     = false
}

variable "min_instances" {
  description = "Minimum number of instances in auto scaling group"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances in auto scaling group"
  type        = number
  default     = 3
}

variable "desired_instances" {
  description = "Desired number of instances in auto scaling group"
  type        = number
  default     = 1
}