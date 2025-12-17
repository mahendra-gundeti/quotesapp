output "server_id" {
  value = azurerm_postgresql_flexible_server.postgres.id
}

output "server_name" {
  value = azurerm_postgresql_flexible_server.postgres.name
}

output "server_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_names" {
  value = [for db in azurerm_postgresql_flexible_server_database.database : db.name]
}

output "admin_username" {
  value = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "connection_string" {
  value     = "postgresql://${azurerm_postgresql_flexible_server.postgres.administrator_login}@${azurerm_postgresql_flexible_server.postgres.fqdn}:5432/${length(var.databases) > 0 ? var.databases[0] : "postgres"}?sslmode=require"
  sensitive = true
}