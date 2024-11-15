variable "environment" {
  description = "Environment you are deploying to e.g. dev/prod"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "lab_1_vpc_cidr" {
  description = "Lab 1 VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "Region to create AWS resources"
  type        = string
  default     = "eu-west-2"
}
