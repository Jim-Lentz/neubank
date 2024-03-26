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
  features {}
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
  name                = "frontend-app"
  resource_group_name = azurerm_resource_group.rg.name #var.resource_group_name
  location            = var.location
  app_service_plan_id = "placeholder" #azurerm_app_service_plan.asp.id # Define this resource or pass the ID if existing
  subnet_id           = module.networking.frontend_subnet_id #module.my_module.azurerm_subnet.subnet["frontend"].id # module.network.frontend_subnet_id # Ensure you have a network module or reference the subnet directly
  environment         = var.environment
  depends_on = [
    azurerm_resource_group.rg
  ]
} 

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}