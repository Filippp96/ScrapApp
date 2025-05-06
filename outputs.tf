output "postgresqlFQDN" {
  value     = azurerm_postgresql_flexible_server.main.fqdn
  sensitive = true
}

/*output "mongodbFQDN" {
  value     = azurerm_cosmosdb_account.main.endpoint
  sensitive = true
}*/

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}