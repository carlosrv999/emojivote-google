output "database_private_ip" {
  value = google_sql_database_instance.default.private_ip_address
}
