resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_service_plan" "frontend_service_plan" {
  name                = "webapp_service_plan-${random_string.resource_code.result}"
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
/*
resource "azurerm_linux_web_app" "frontend" {
  name                = "webapp-service-${random_string.resource_code.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.frontend_service_plan.id 
  virtual_network_subnet_id = var.subnet_id #azurerm_subnet.subnet["frontend"].id

  site_config {
    minimum_tls_version = "1.2"
  }

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.frontend.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
} */