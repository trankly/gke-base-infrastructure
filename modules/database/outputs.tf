output "cloud-sql-connection-name" {
  value = google_sql_database_instance.postgresql.connection_name
}

output "cloud-sql-instance-name" {
  value = google_sql_database_instance.postgresql.name
}