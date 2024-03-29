#Frontend
# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "front-end-webapp" {
  name                  = "neubank-webapp"
  location              = var.location
  resource_group_name   = var.resource_group_name
  service_plan_id       = var.app_service_plan_id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    always_on = true

    application_stack {
      node_version = "16-lts"
    }
  }
  
  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = var.insights-instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
  }

/*  
  depends_on = [
    azurerm_service_plan.frond-end-asp,azurerm_application_insights.fg-appinsights
  ]
*/
}


#Backend
#storage account for functionapp
resource "azurerm_storage_account" "fn-storageaccount" {
  name                     = "fgfunctionappsa2023xyse"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_function_app" "back-end-fnapp" {
  name                = "back-end-function-app"
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name       = azurerm_storage_account.fn-storageaccount.name
  storage_account_access_key = azurerm_storage_account.fn-storageaccount.primary_access_key
  service_plan_id            = var.back-end-app_service_plan_id
  

  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = var.insights-instrumentation_key
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    
  
  }

  site_config {

  ip_restriction {
          virtual_network_subnet_id = var.front-end-subnet_id
          priority = 100
          name = "Frontend access only"
           }
  application_stack {
      python_version = 3.8
    }
  }

  identity {
  type = "SystemAssigned"
   }

 depends_on = [
   azurerm_storage_account.fn-storageaccount
 ]
}

#vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "be-vnet-integration" {
  app_service_id = azurerm_linux_function_app.back-end-fnapp.id
  subnet_id      = var.back-end-subnet_id
  depends_on = [
    azurerm_linux_function_app.back-end-fnapp
  ]
}

#vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "fe-vnet-integration" {
  app_service_id = azurerm_linux_web_app.front-end-webapp.id
  subnet_id      = var.front-end-subnet_id

  depends_on = [
    azurerm_linux_web_app.front-end-webapp
  ]
}

output "frontend_url" {
  
  value = "${azurerm_linux_web_app.front-end-webapp.name}.azurewebsites.net"
}