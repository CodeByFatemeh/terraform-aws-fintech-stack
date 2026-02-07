# Create the Application Load Balancer
resource "aws_lb" "main_alb" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_config.security_groups
  subnets            = var.alb_config.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

# Define the Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.name_prefix}-tg"
  port     = var.target_group_config.port
  protocol = var.target_group_config.protocol
  vpc_id   = var.alb_config.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.target_group_config.health_check.healthy_threshold
    unhealthy_threshold = var.target_group_config.health_check.unhealthy_threshold
    timeout             = var.target_group_config.health_check.timeout
    interval            = var.target_group_config.health_check.interval
    path                = var.target_group_config.health_check.path
    port                = var.target_group_config.health_check.port
  }
}

# HTTP Listener: Automatically redirects all traffic from port 80 to HTTPS (port 443)
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener: Main secure entry point
resource "aws_lb_listener" "https_secure" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # **** Replace with your actual ACM Certificate ARN
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}