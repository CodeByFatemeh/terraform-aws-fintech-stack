# modules/database/outputs.tf

# Address of the database cluster endpoint
output "db_instance_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.postgresql.endpoint
}

# Address of the read-only database cluster endpoint 
output "db_reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster"
  value       = aws_rds_cluster.postgresql.reader_endpoint
}

# Cluster ID of the Aurora database
output "db_cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = aws_rds_cluster.postgresql.id
}

# Database port
output "db_port" {
  description = "The database port"
  value       = aws_rds_cluster.postgresql.port
}