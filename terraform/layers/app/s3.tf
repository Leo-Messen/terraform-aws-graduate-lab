locals {
  resource_name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_s3_bucket" "s3_webfiles_bucket" {
  bucket = "${local.resource_name_prefix}-webfiles"
}

resource "aws_s3_object" "index_html_file" {
  bucket = "${local.resource_name_prefix}-webfiles"
  key    = "index.html"
  source = var.index_html_path
  etag   = filemd5(var.index_html_path)
}
