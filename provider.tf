terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

# Example Terraform Cloud backend (uncomment and fill in if you want Terraform Cloud to run this workspace)
  backend "remote" {
    organization = "AWS-Geepee"

    workspaces {
      name = "terraform-x-aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}