resource "azurerm_service_plan" "frontend_service_plan" {
  name                = "webapp_service_plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B2"

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_linux_web_app" "frontend" {
  name                = "webapp-service-${random_string.resource_code.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.frontend_service_plan.id #var.app_service_plan_id

  site_config {}

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}