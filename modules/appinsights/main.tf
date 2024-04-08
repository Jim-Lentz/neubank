# for telemetry data from the applications
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.environment}Calculator-appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

output "instrumentation_key" {
  value = azurerm_application_insights.app_insights.instrumentation_key
}