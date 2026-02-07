# Terraform Block: defining required version and providers
terraform {
  required_version = ">= 1.5.0" # Ensuring compatibility with modern Terraform features

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Using AWS Provider version 5.x for latest features
    }
  }
}

# Provider Block: Configuring AWS credentials and region
provider "aws" {
  region = var.aws_region # Managed via variables.tf

  # Default Tags: Every resource created will automatically have these tags
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = local.environment
      ManagedBy   = "Terraform"
      Owner       = local.owner
      CreatedAt   = "2026-02-01"
    }
  }
}