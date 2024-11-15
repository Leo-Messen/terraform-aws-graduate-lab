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

variable "index_html_path" {
  description = "Path to index.html webfile"
  type        = string
  default     = "src/index.html"
}

variable "web_user_data_path" {
  description = "Path to ec2 user data file"
  type        = string
  default     = "src/ec2WebUserData.tftpl"
}

variable "ec2_web_instance_type" {
  description = "Instance type for ec2 web servers"
  type        = string
  default     = "t2.micro"
}
