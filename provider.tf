terraform {
required_version = ">= 1.2.0"

# Example Terraform Cloud backend (uncomment and fill in if you want Terraform Cloud to run this workspace)
backend "remote" {
organization = "your-tfc-org"
workspaces {
name = "your-workspace-name"
}
}
}

provider "aws" {
region = var.aws_region
}