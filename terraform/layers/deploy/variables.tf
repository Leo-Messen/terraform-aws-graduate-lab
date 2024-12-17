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

################################################################################
# Codebuild
################################################################################

variable "codebuild_image" {
  description = "CodeBuild image"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
}

variable "codebuild_node_size" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "terraform_version" {
  description = "Terraform version to use in codepipeline"
  type        = string
  default     = "1.9.8"
}
