variable "name_prefix" {
  type = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM SSL certificate"
  type        = string
}

variable "alb_config" {
  description = "Network and security configuration for the Application Load Balancer"
  type = object({
    vpc_id          = string
    public_subnets  = list(string)
    security_groups = list(string)
  })
}

variable "target_group_config" {
  description = "Target Group configuration"
  type = object({
    port     = number
    protocol = string
    health_check = object({
      path                = string
      port                = string
      healthy_threshold   = number
      unhealthy_threshold = number
      threshold           = number
      timeout             = number
      interval            = number
    })
  })
  default = {
    port     = 80
    protocol = "HTTP"
    health_check = {
      path                = "/"
      port                = "traffic-port"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      threshold           = 5
      timeout             = 5
      interval            = 30
    }
  }
}
