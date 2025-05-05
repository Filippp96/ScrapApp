output "postgresql_password" {
  value     = azurerm_key_vault_secret.postgresql_password.value
  sensitive = true
}

output "postgresql_login" {
  value     = azurerm_key_vault_secret.postgresql_login.value
  sensitive = true
}

output "mongodb_password" {
  value     = azurerm_key_vault_secret.mongodb_password.value
  sensitive = true
}

output "mongodb_login" {
  value     = azurerm_key_vault_secret.mongodb_login.value
  sensitive = true
}