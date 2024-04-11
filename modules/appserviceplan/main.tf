resource "azurerm_service_plan" "front-end-asp" {
  name                = "front-end-asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  
  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}



resource "azurerm_service_plan" "back-end-asp" {
  name                = "back-end-asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  
  tags = {
    Environment = var.environment
    Owner       = "first.last@company.com"
    Project     = "Mortgage Calculator"
  }
}

output "front-end-asp" {
  value = azurerm_service_plan.front-end-asp.id
}

output "back-end-asp" {
  value = azurerm_service_plan.back-end-asp.id
}