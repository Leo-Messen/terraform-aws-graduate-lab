data "aws_ami" "latest_ubuntu20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "ec2_web_launch_template" {
  name = "ec2_web_launch_template"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_s3_profile.arn
  }

  image_id = data.aws_ami.latest_ubuntu20.id

  instance_type = "t2.micro"

  user_data = filebase64("${var.web_user_data_path}")
}
