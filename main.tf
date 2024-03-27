 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
    backend "azurerm" {
      resource_group_name  = "tfstate-dev"
      storage_account_name = "tfstatef7op9"
      container_name       = "tfstate-dev"
      key                  = "terraform.tfstate"
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
  name     = "dev-rgp-cis-neubank-use-001"
  location = var.location

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

module "networking" {
  source = "./modules/network"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

 module "frontend" {
  source              = "./modules/frontend"
  name                = "frontend-app-jklsrn84n3"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  app_service_plan_id = "placeholder" 
  subnet_id           = module.networking.frontend_subnet_id 
  environment         = var.environment
  depends_on = [
    azurerm_resource_group.rg
  ]
} 

/* module "backend" {
  source              = "./modules/appserver"
  name                = "backend-app-jklsrn84n3"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  app_service_plan_id = "placeholder" 
  subnet_id           = module.networking.backend_subnet_id 
  environment         = var.environment
  depends_on = [
    azurerm_resource_group.rg
  ]
} 

module "database" {
  source              = "./modules/database"
  name                = "sql-server"
  resource_group_name = azurerm_resource_group.rg.name 
  location            = var.location
  subnet_id           = module.networking.database_subnet_id 
  environment         = var.environment
  depends_on = [
    azurerm_resource_group.rg
  ]
} 
*/
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
