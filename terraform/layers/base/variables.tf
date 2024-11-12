variable "default_tags" {
  description = "Common default tags for all deployed resources"
  type        = map(any)
}

variable "environment" {
  description = "Environment you are deploying to e.g. dev/prod"
  type        = string
}

variable "project_name" {
  description = "Name of project"
  type        = string
}

