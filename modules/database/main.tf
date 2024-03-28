resource "azurerm_sql_server" "sqlserver" {
  name                         = "sqlserver-mywebapp"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "someStrongPassword!"

  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sqlserver.name
  subnet_id           = var.subnet_id
  depends_on = [ azurerm_sql_server.sqlserver ]
}

resource "azurerm_storage_account" "sql_storage" {
  name                     = "sql_storage"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}


resource "azurerm_sql_database" "sqldb" {
  name                = "sqldb-mywebapp"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sqlserver.name

  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
  depends_on = [ azurerm_sql_server.sqlserver, azurerm_storage_account.sql_storage ]
}

output "database_server_name" {
  value = azurerm_sql_server.sqlserver.name
}

output "sqlserver_ip" {
  value = azurerm_sql_virtual_network_rule.sqlserver_ip
}

output "sql_server_fqdn" {
  value = azurerm_sql_server.sqlserver.fully_qualified_domain_name
}