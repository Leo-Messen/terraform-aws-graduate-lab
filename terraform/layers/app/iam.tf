resource "aws_iam_role" "ec2_get_webfiles_role" {
  name = "ec2-get-webfiles-role"
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
  name = "ec2-get-webfiles-policy"
  role = aws_iam_role.ec2_get_webfiles_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "${data.aws_s3_bucket.s3_webfiles_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2_get_webfiles_profile"
  role = aws_iam_role.ec2_get_webfiles_role.id
}
