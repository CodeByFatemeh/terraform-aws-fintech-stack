variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance type"
}

# تجمیع متغیرهای مربوط به شبکه در قالب یک شیء
variable "network_config" {
  description = "Network configuration for the compute module"
  type = object({
    vpc_id             = string
    private_subnet_ids = list(string)
    app_sg_id          = string
    target_group_arn   = string
  })
}

# تجمیع متغیرهای مربوط به تنظیمات اپلیکیشن (اختیاری برای نظم بیشتر)
variable "app_settings" {
  description = "Application specific settings"
  type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
  })
  default = {
    min_size         = 1
    max_size         = 3
    desired_capacity = 1
  }
}