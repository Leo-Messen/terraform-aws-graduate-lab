resource "aws_iam_role" "ec2_get_webfiles_role" {
  name = "${local.resource_name_prefix}-ec2-get-webfiles-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_get_webfiles_policy" {
  name = "${local.resource_name_prefix}-ec2-get-webfiles-policy"
  role = aws_iam_role.ec2_get_webfiles_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListObject"
        ]
        Effect = "Allow"
        Resource = [
          "${data.aws_s3_bucket.s3_webfiles_bucket.arn}",
          "${data.aws_s3_bucket.s3_webfiles_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "${local.resource_name_prefix}-ec2_get_webfiles_profile"
  role = aws_iam_role.ec2_get_webfiles_role.id
}
