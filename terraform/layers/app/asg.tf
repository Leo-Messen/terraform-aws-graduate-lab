data "aws_ami" "latest_amazonlinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_subnets" "grad_lab_1_vpc_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.grad_lab_1_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_prefix}-vpc-private-*"]
  }
}

resource "aws_launch_template" "ec2_web_launch_template" {
  name = "${local.resource_name_prefix}-ec2_web_launch_template"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_s3_profile.arn
  }

  image_id = data.aws_ami.latest_amazonlinux.id

  instance_type = "t2.micro"

  user_data = filebase64("${var.web_user_data_path}")
}

resource "aws_autoscaling_group" "ec2_web_asg" {
  name                      = "${local.resource_name_prefix}-ec2_web_asg"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = data.aws_subnets.grad_lab_1_vpc_private_subnets.ids // across all private subnets

  target_group_arns = [for k in module.grad_lab_1_alb.target_groups : k.arn]

  launch_template {
    id = aws_launch_template.ec2_web_launch_template.id
  }

}
