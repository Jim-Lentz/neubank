resource "azurerm_service_plan" "front-end-asp" {
  name                = "front-end-asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  #depends_on = [
  #  module.network.azurerm_subnet.front-end-subnet.id
  #]
}



resource "azurerm_service_plan" "back-end-asp" {
  name                = "back-end-asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
  #depends_on = [
  #  module.network.azurerm_subnet.back-end-subnet.id
  #]
}

output "front-end-asp" {
  value = azurerm_service_plan.front-end-asp.id
}

output "back-end-asp" {
  value = azurerm_service_plan.back-end-asp.id
}