resource "azurerm_resource_group" "main" {
  name     = "ScrapApp_RG"
  location = "westeurope"
  tags     = {}
}

// --=== POSTGRESQL DATABASE ===--
resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "postgresql-scrap-app"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = "16"
  public_network_access_enabled = true
  administrator_login           = azurerm_key_vault_secret.postgresql_login.value
  administrator_password        = azurerm_key_vault_secret.postgresql_password.value
  storage_mb                    = 32768
  storage_tier                  = "P4"
  sku_name                      = "B_Standard_B1ms"
  zone                          = "1"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allowFilip" {
  name             = "FilipIP"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = var.IPF
  end_ip_address   = var.IPF
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allowPiotrekS" {
  name             = "PiotrekSIP"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = var.IPPS
  end_ip_address   = var.IPPS
}

/*resource "azurerm_postgresql_flexible_server_firewall_rule" "allowPiotrekP" {
  name             = "PiotrekPIP"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = var.IPPP
  end_ip_address   = var.IPPP
}*/


// ---== MONGO DATABASE ==---
resource "azurerm_cosmosdb_account" "main" {
  name                          = "mongodb-scrap-app"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  offer_type                    = "Standard"
  kind                          = "MongoDB"
  free_tier_enabled             = true
  public_network_access_enabled = true
  mongo_server_version          = "7.0"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }

  backup {
    type = "Continuous"
    tier = "Continuous7Days"
  }
}

resource "azurerm_cosmosdb_mongo_database" "main" {
  name                = "mongo-db-scrap-app"
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  throughput          = 400
}

resource "azurerm_cosmosdb_mongo_collection" "main" {
  name                = "mongo-collection-scrap-app"
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_mongo_database.main.name

  default_ttl_seconds = "777"
  shard_key           = "mongodbScrapAppKey"
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }
}