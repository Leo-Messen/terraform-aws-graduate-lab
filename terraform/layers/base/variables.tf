variable "environment" {
  description = "Environment you are deploying to e.g. dev/prod"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "lab-1-vpc-cidr" {
  description = "Lab 1 VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "lab-1-vpc-name" {
  description = "Lab 1 VPC name"
  type        = string
  default     = "lab-1-vpc"
}
