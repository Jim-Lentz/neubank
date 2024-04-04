resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.environment}-blobstoragefhdk38eu209" # Name must be unique across Azure
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}