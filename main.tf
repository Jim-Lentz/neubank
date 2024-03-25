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

module "my_module" {
  source = "./modules/network"
}