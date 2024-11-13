terraform {
  required_version = "~> 1.9.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      ProjectName = var.project_name
      CreatedBy   = "Terraform"
    }
  }
}
