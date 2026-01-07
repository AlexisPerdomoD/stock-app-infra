

output "cr_host" {
  description = "CockroachDB cluster hostname"
  # value       = cockroach_cluster.this.account_id != null ? "${cockroach_cluster.this.id}.${cockroach_cluster.this.cloud_provider}.cockroachlabs.cloud" : cockroach_cluster.this.regions[0].sql_dns
  value = cockroach_cluster.this.regions[0].sql_dns

}

output "cr_port" {
  description = "CockroachDB cluster port"
  value       = 26257 # Puerto por defecto de CockroachDB
}

output "cr_user" {
  description = "CockroachDB application user"
  value       = cockroach_sql_user.app.name
}

output "cr_password" {
  description = "CockroachDB application user password"
  value       = random_password.db.result
  sensitive   = true
}

output "cr_db" {
  description = "CockroachDB database name"
  value       = cockroach_database.app.name
}

output "cr_ssl" {
  description = "CockroachDB SSL mode"
  value       = "verify-full"
}

output "cr_connection_string" {
  description = "CockroachDB connection string"
  value       = "postgresql://${cockroach_sql_user.app.name}:${random_password.db.result}@${cockroach_cluster.this.regions[0].sql_dns}:26257/${cockroach_database.app.name}?sslmode=verify-full"
  sensitive   = true
}

output "cr_cluster_id" {
  description = "CockroachDB cluster ID"
  value       = cockroach_cluster.this.id
}
