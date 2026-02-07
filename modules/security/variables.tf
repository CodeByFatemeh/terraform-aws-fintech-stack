variable "vpc_id" {
  description = "The ID of the VPC where SGs will be created"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming the security groups"
  type        = string
}