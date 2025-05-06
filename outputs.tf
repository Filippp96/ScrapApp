output "postgresqlFQDN" {
  value     = azurerm_postgresql_flexible_server.main.fqdn
  sensitive = true
}

/*output "mongodbFQDN" {
  value     = azurerm_cosmosdb_account.main.endpoint
  sensitive = true
}*/

