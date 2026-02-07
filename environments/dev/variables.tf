# AWS Region variable
variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

# Project naming for identification
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "Finance-Infrastructure"
}

locals {
  safe_project_name = lower(var.project_name)
}

# Deployment Environment
variable "environment" {
  description = "Environment name (e.g. staging, production)"
  type        = string
  default     = "production"
}

# Instance Type for EC2
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "db_username" {
  description = "The username for the database"
  type = string
}

variable "db_password" {
    description = "The password for the database (sensitive)."
    type = string
    sensitive = true
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for the ALB"
  type        = string
}