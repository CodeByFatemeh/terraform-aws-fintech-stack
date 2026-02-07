# Database Subnet Group
resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.name_prefix}-aurora-subgroup"
  subnet_ids = var.network_config.subnet_ids

  tags = merge(
    { Name = "${var.name_prefix}-subnet-group" },
    var.extra_tags
  )
}

# KMS Key for Encryption at Rest
resource "aws_kms_key" "db_key" {
  description             = "KMS key for ${var.name_prefix} Aurora Encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = var.extra_tags
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "postgresql" {
  cluster_identifier = "${var.name_prefix}-cluster"
  engine             = var.db_config.engine
  engine_version     = var.db_config.engine_version
  database_name      = var.db_config.database_name
  master_username    = var.db_config.username
  master_password    = var.db_config.password

  # Security & Compliance
  iam_database_authentication_enabled = true
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.db_key.arn
  deletion_protection                 = false // set to true in Production Environments

  # Network & Access
  db_subnet_group_name   = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids = var.network_config.security_group_ids

  # Backup & Logging
  backup_retention_period         = 7
  preferred_backup_window         = "02:00-03:00"
  copy_tags_to_snapshot           = true
  enabled_cloudwatch_logs_exports = ["postgresql", "error"]

  tags = merge({
    Environment = "production"
    Security    = "High"
    Compliance  = "PCI-DSS"
    },
  var.extra_tags)
}

# Multi-AZ Instances
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = 2
  identifier           = "${var.name_prefix}-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.postgresql.id
  instance_class       = var.db_config.instance_class
  engine               = aws_rds_cluster.postgresql.engine
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name

  # Monitoring
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = true

  tags = var.extra_tags

}

# IAM Role for Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.name_prefix}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
