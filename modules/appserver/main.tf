 resource "azurerm_service_plan" "backend_service_plan" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "S1"

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

resource "azurerm_linux_web_app" "backend" {
  name                = "backend-app-service-${random_string.resource_code.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.backend_service_plan.id 
  virtual_network_subnet_id = var.subnet_id 
  public_network_access_enabled = false

  site_config {}

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

output "backend_url" {
  value = azurerm_linux_web_app.backend.default_site_hostname
}