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
  location = "East US"

  tags = {
    Environment = "Dev"
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

module "network" {
  source = "./modules/network"
}

/* module "frontend" {
  source              = "./modules/frontend"
  name                = "frontend-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.asp.id # Define this resource or pass the ID if existing
  subnet_id           = module.network.frontend_subnet_id # Ensure you have a network module or reference the subnet directly
} */