resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.environment}blobstoragefhdk38eu" # Name must be unique across Azure
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

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
/*
resource "azurerm_private_endpoint" "frontend" {
  name                 = "blob_private_endpoint"
  location             = var.location
  resource_group_name  = var.resource_group_name
  subnet_id            = var.frontend_subnet_id

  private_service_connection {
    name                           = "blob_psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
}
*/
/*
resource "azurerm_private_endpoint" "backend" {
  name                 = "blob_private_endpoint"
  location             = var.location
  resource_group_name  = var.resource_group_name
  subnet_id            = var.backend_subnet_id

  private_service_connection {
    name                           = "blob_psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
  }
}
*/