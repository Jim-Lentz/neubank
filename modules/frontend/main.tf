resource "azurerm_app_service_plan" "frontend_service_plan" {
  name                = "webapp_service_plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = {
    Environment = "Dev"
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

resource "azurerm_app_service" "frontend" {
  name                = webapp_service
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    dotnet_framework_version = "v4.0" # Example, adjust according to your application
  }
  tags = {
    Environment = "Dev"
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}