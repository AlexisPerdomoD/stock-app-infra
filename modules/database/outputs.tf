
output "database_url" {
  sensitive = true
  value = format(
    "postgresql://%s:%s@%s/%s?sslmode=verify-full",
    cockroachdb_user.app.name,
    cockroachdb_user.app.password,
    cockroachdb_cluster.this.connection_strings[0].connection_string,
    cockroachdb_database.app.name
  )
}
