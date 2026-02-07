variable "name_prefix" {
  type        = string
  description = "prefix for naming resources"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "network_config" {
  description = "Network configuration for the compute module"
  type = object({
    vpc_id             = string
    private_subnet_ids = list(string)
    app_sg_id          = string
    target_group_arn   = string
  })
}

variable "app_settings" {
  description = "Application specific settings"
  type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
  })
  default = {
    min_size         = 2
    max_size         = 4
    desired_capacity = 2
  }
}