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

data "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id       = data.aws_vpc.grad_lab_1_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
}

// SECURITY GROUP 
resource "aws_security_group" "grad_lab_1_asg_sg" {
  name   = "${local.resource_name_prefix}-asg-sg"
  vpc_id = data.aws_vpc.grad_lab_1_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_asg_http_traffic_ingress" {
  security_group_id = aws_security_group.grad_lab_1_asg_sg.id

  referenced_security_group_id = module.grad_lab_1_alb.security_group_id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_asg_https_traffic_ingress" {
  security_group_id = aws_security_group.grad_lab_1_asg_sg.id

  referenced_security_group_id = module.grad_lab_1_alb.security_group_id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_asg_endpoint_egress" {
  security_group_id = aws_security_group.grad_lab_1_asg_sg.id

  prefix_list_id = data.aws_vpc_endpoint.s3_gateway_endpoint.prefix_list_id
  ip_protocol    = -1
}

// LAUNCH TEMPLATE AND ASG
resource "aws_launch_template" "ec2_web_launch_template" {
  name                   = "${local.resource_name_prefix}-ec2-web-launch-template"
  vpc_security_group_ids = [aws_security_group.grad_lab_1_asg_sg.id]


  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_get_webfiles_profile.arn
  }

  image_id = data.aws_ami.latest_amazonlinux.id

  instance_type = var.ec2_web_instance_type

  user_data = base64encode(templatefile("${var.web_user_data_path}",
    { bucket_name = data.aws_s3_bucket.s3_webfiles_bucket.id }
  ))

}

resource "aws_autoscaling_group" "ec2_web_asg" {
  name                = "${local.resource_name_prefix}-ec2-web-asg"
  max_size            = 3
  min_size            = 2
  health_check_type   = "ELB"
  desired_capacity    = 2
  vpc_zone_identifier = data.aws_subnets.grad_lab_1_vpc_private_subnets.ids // across all private subnets

  target_group_arns = [for k in module.grad_lab_1_alb.target_groups : k.arn]

  launch_template {
    id = aws_launch_template.ec2_web_launch_template.id
  }

}
