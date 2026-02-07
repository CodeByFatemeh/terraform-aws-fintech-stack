variable "name_prefix" {
  description = "Prefix for naming resources, passed from the environment level"
  type        = string
}

# Network Configuration: VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnets (For Load Balancers or NAT Gateways)
variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private Subnets (For EC2 and Databases)
variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}
