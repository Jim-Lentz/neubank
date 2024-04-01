#Create Random password 
resource "random_password" "randompassword" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#Create Key Vault Secret
resource "azurerm_key_vault_secret" "sqladminpassword" {
  name         = "sqladmin"
  value        = random_password.randompassword.result
  key_vault_id = var.valult-id
  content_type = "text/plain"

  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
  /*depends_on = [
    azurerm_key_vault.fg-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01,azurerm_key_vault_access_policy.kv_access_policy_02,azurerm_key_vault_access_policy.kv_access_policy_03
  ] */
}

#Azure sql database
resource "azurerm_mssql_server" "azuresql" {
  name                         = "fg-sqldb-${var.environment}" 
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4adminu$er"
  administrator_login_password = random_password.randompassword.result

  azuread_administrator {
    login_username = "AzureAD Admin"
    object_id      = "86f50fc0-0d0d-4c26-941d-17dd64ed03a6"
  }

  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}

#add subnet from the backend vnet
resource "azurerm_mssql_virtual_network_rule" "allow-be" {
  name      = "be-sql-vnet-rule"
  server_id = azurerm_mssql_server.azuresql.id
  subnet_id = var.subnet_id
  depends_on = [
    azurerm_mssql_server.azuresql
  ]
}

resource "azurerm_mssql_database" "fg-database" {
  name           = "fg-db"
  server_id      = azurerm_mssql_server.azuresql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

 tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}

resource "azurerm_key_vault_secret" "sqldb_cnxn" {
  name = "fgsqldbconstring"
  value = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:fg-sqldb-prod.database.windows.net,1433;Database=fg-db;Uid=4adminu$er;Pwd=${random_password.randompassword.result};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  key_vault_id = var.valult-id

  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}