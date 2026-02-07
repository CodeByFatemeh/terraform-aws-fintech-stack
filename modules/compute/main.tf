# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Template for EC2 Instances
resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.name_prefix}-tpl-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.network_config.app_sg_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform at $(hostname -f)</h1>" > /var/www/html/index.html
              EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.name_prefix}-asg"
  vpc_zone_identifier = var.network_config.private_subnet_ids # Assuming private subnets for security
  target_group_arns   = [var.network_config.target_group_arn]
  health_check_type   = "ELB"

  min_size         = var.app_settings.min_size
  max_size         = var.app_settings.max_size
  desired_capacity = var.app_settings.desired_capacity

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-asg-node"
    propagate_at_launch = true
  }
}
