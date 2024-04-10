resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.environment}blobstoragefhdk38eu" # Name must be unique across Azure
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  public_network_access_enabled = false
  shared_access_key_enabled = false

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.frontend_subnet_id, var.backend_subnet_id]
  }

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}
