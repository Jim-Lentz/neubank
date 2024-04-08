# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-rgp-cis-neubank-use-001"
  location = var.location

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}