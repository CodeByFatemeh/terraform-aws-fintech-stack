# VPC Information
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Aurora Cluster Outputs
output "aurora_cluster_endpoint" {
  description = "The cluster endpoint (Writer)"
  value       = aws_rds_cluster.postgresql.endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.postgresql.reader_endpoint
}

output "aurora_cluster_port" {
  description = "The database port"
  value       = aws_rds_cluster.postgresql.port
}

# Security Information
output "db_security_group_id" {
  description = "The ID of the security group assigned to the database"
  value       = aws_security_group.db_sg.id
}

# Network Information
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}