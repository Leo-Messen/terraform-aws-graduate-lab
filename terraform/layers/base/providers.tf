terraform {
  required_version = "~> 1.9.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  default_tags {
    tags = var.default_tags
  }
}
