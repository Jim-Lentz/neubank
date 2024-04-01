terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

/*
resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "East US"
  tags = {
    Environment = "global"
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}
*/

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatenuebank${random_string.resource_code.result}"
  resource_group_name      = "tfstate" #azurerm_resource_group.tfstate.name
  location                 = "East US" #azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    Environment = "global"
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}