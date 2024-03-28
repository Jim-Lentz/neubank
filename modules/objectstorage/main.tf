resource "azurerm_storage_account" "storage_account" {
  name                     = "mcblobstoragexxx" # Name must be unique across Azure
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Dev"
    Project     = "Mortgage Calculator"
  }
}