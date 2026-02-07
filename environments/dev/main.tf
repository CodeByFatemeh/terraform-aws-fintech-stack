terraform {
  backend "s3" {
    bucket         = "tima-finance-tfstate-509c986e"     # Bucket name that you created
    key            = "finance/network/terraform.tfstate" # File path within the bucket
    region         = "us-east-1"                         # AWS region of the S3 bucket
    dynamodb_table = "tima-finance-tfstate-locks"        # Table for state locking
    encrypt        = true
  }
}

locals {
  project_name = "finance-infrastructure"
  environment  = "production"
  owner        = "Tima-Finance-Team"

  // Prefix for resource names to maintain consistency in AWS console
  name_prefix = local.project_name
}

# Calling the VPC module
module "vpc" {
  # Add the path to the VPC module 
  source = "../../modules/vpc"

  # Passing the prefix for naming resources
  name_prefix = local.name_prefix

  # Configuring VPC and Subnets for Dev Environment
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
}

#  Calling the Security Groups module
module "security" {
  source = "../../modules/security"
  # Passing the prefix for naming resources
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
}

# Calling the IAM module
module "iam" {
  source = "../../modules/iam"
  # Passing the prefix for naming resources
  name_prefix = local.name_prefix
}

# Calling the Database module
module "database" {
  source      = "../../modules/database"
  name_prefix = local.name_prefix

  db_config = {
    username    = var.db_username
    password    = var.db_password
    engine         = "aurora-postgresql"
    engine_version = "15.4"
    database_name  = "fintech_db"
    instance_class = "db.t3.medium"
  }

  # Passing network configuration to the database module
  network_config = {
    vpc_id                 = module.vpc.vpc_id
    subnet_ids             = module.vpc.private_subnet_ids
    security_group_ids = [module.security.db_sg_id]
  }
}

# Calling the Compute module
module "compute" {
  source = "../../modules/compute"

  name_prefix = local.name_prefix
  network_config = {
    vpc_id             = module.vpc.vpc_id
    private_subnet_ids = module.vpc.private_subnet_ids
    app_sg_id          = module.security.app_sg_id
    target_group_arn   = module.load_balancing.target_group_arn
  }

  app_settings = {
    min_size         = 2
    max_size         = 4
    desired_capacity = 2
  }
}

# Calling the Load Balancing module
module "load_balancing" {
  source          = "../../modules/alb"
  name_prefix     = local.name_prefix
  certificate_arn = var.certificate_arn

  alb_config = {
    vpc_id          = module.vpc.vpc_id
    public_subnets  = module.vpc.public_subnet_ids
    security_groups = [module.security.alb_sg_id]
  }

  target_group_config = {
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
