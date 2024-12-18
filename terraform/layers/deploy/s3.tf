resource "aws_s3_bucket" "codepipeline_tf_deploy" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.environment}-codepipeline-${var.project_name}"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_tf_deploy" {
  bucket                  = aws_s3_bucket.codepipeline_tf_deploy.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_tf_deploy" {
  bucket = aws_s3_bucket.codepipeline_tf_deploy.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "codepipeline_tf_deploy" {
  bucket = aws_s3_bucket.codepipeline_tf_deploy.bucket
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.codepipeline_tf_deploy]
}

resource "aws_s3_bucket_versioning" "codepipeline_tf_deploy" {
  bucket = aws_s3_bucket.codepipeline_tf_deploy.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
