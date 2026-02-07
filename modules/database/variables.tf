variable "name_prefix" {
  type = string
}

variable "db_config" {
  type = object({
    username          = string
    password          = string
    engine            = string
    engine_version    = string
    instance_class    = string
    database_name     = string
  })
  sensitive   = true
  description = "Database configuration object"
}

# variable "db_username" {
#   type      = string
#   sensitive = true
# }

# variable "db_password" {
#   type      = string
#   sensitive = true
# }

variable "network_config" {
  type = object({
    vpc_id             = string
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  description = "Network configuration for the database"
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}

# variable "subnet_ids" {
#   type        = list(string)
#   description = "List of subnet IDs for the database subnet group"
# }

# variable "vpc_security_group_ids" {
#   type        = list(string)
#   description = "VPC Security Group IDs for the database"
# }
