variable "aws_region" {
    description = "AWS region to create resources in"
    type = string
    default = "us-east-1"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    type = string
    default = "10.0.2.0/24"
}

variable "availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    description = "Existing EC2 KeyPair name for SSH access"
    type = string
}

variable "db_username" {
    type = string
    default = "admin"
}

variable "db_password" {
    type = string
    sensitive = true
}

variable "db_allocated_storage" {
    type = number
    default = 20
}

variable "db_instance_class" {
    type = string
    default = "db.t3.micro"
}

variable "tags" {
    type = map(string)
    default = {
    Owner = "terraform"
    Env = "dev"
}
}