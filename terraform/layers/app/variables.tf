variable "environment" {
  description = "Environment you are deploying to e.g. dev/prod"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

variable "region" {
  description = "Region to create AWS resources"
  type        = string
  default     = "eu-west-2"
}
