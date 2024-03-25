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