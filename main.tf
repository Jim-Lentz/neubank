 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
/*    backend "azurerm" {
      resource_group_name  = "tfstate-dev"
      storage_account_name = "tfstatef7op9"
      container_name       = "tfstate-dev"
    #  key                  = "terraform.tfstate" # Injected via commandline argument 
  }
  */
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstatenuebankf7op9"
      container_name       = "tfstate"
    #  key                  = "terraform.tfstate" # Injected via commandline argument 
  }

}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

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

data "azurerm_client_config" "current" {}



resource "azurerm_key_vault" "fg-keyvault" {
  name                        = "fgkeyvault2024"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"


}

resource "azurerm_key_vault_access_policy" "kv_access_policy_01" {
  #This policy adds databaseadmin group with below permissions
  key_vault_id       = azurerm_key_vault.fg-keyvault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  key_permissions    = ["Get", "List"]
  secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]

  depends_on = [azurerm_key_vault.fg-keyvault]
}



# for telemetry data from the applications
resource "azurerm_application_insights" "app_insights" {
  name                = "Calculator-appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
  depends_on = [ azurerm_resource_group.rg ]
}

module "networking" {
  source         = "./modules/network"
  environment    = var.environment
  depends_on     = [
    azurerm_resource_group.rg
  ]
}

module "appserviceplan" {
  source              = "./modules/appserviceplan"
  location            = var.location
  resource_group_name = var.resource_group_name
  environment         = var.environment
  depends_on = [ module.networking ]
}

 module "compute" {
  source              = "./modules/compute"
  name                = "frontend-app-jklsrn84n3"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  app_service_plan_id = module.appserviceplan.front-end-asp
  back-end-app_service_plan_id = module.appserviceplan.back-end-asp
  front-end-subnet_id = module.networking.front-end-subnet 
  back-end-subnet_id  = module.networking.back-end-subnet
  insights-instrumentation_key = azurerm_application_insights.app_insights.instrumentation_key
  environment         = var.environment
  depends_on = [
    azurerm_resource_group.rg
  ]
} 

# Disabled this takes 20 minutes to come up. 
/*
 module "redis" {
   source = "./modules/redis"
   resource_group_name = azurerm_resource_group.rg.name 
   location            = var.location
   subnet_id           = module.networking.back-end-subnet 
 }
*/

module "database" {
  source = "./modules/database"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  subnet_id           = module.networking.back-end-subnet
  environment         = var.environment
  valult-id           = azurerm_key_vault.fg-keyvault.id
  depends_on = [
  azurerm_key_vault.fg-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01
  ]
}

module "objectstorage" {
  source = "./modules/objectstorage"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  environment         = var.environment
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "frontend_url" {
  
  value = module.compute.frontend_url
}
