
data "aws_vpc" "grad_lab_1_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_prefix}-vpc"]
  }
}

data "aws_subnets" "grad_lab_1_vpc_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.grad_lab_1_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${local.resource_name_prefix}-vpc-public-*"]
  }
}

module "grad_lab_1_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${local.resource_name_prefix}-alb"                // use resource prefix -alb
  vpc_id  = data.aws_vpc.grad_lab_1_vpc.id                     // get vpc id
  subnets = data.aws_subnets.grad_lab_1_vpc_public_subnets.ids // get all PUBLIC subnets from VPC

  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = { // open on all HTTP and HTTPS ports
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = { // egress on all ports
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  listeners = { // add listener on port 80
    http_listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "grad-lab-1-asg"
      }
    }
  }

  target_groups = {
    grad-lab-1-asg = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

  }
}
