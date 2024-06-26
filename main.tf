 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
  }

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


module "resource_group" {
  source              = "./modules/resourcegroup"
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name
}

module "keyvault" {
  source              = "./modules/keyvault"
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name

  depends_on     = [
    module.resource_group.id
  ]
}


# for telemetry data from the applications
module "appinsights"{
  source = "./modules/appinsights"
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name
  depends_on     = [
    module.resource_group.id
  ]
}


module "networking" {
  source              = "./modules/network"
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name
  depends_on     = [
    module.resource_group.id
  ]
}

module "appserviceplan" {
  source              = "./modules/appserviceplan"
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  environment         = var.environment
  depends_on = [ module.networking ]
}

 module "compute" {
  source              = "./modules/compute"
  name                = "frontend-app-jklsrn84n3"
  resource_group_name = module.resource_group.resource_group_name 
  location            = var.location
  app_service_plan_id = module.appserviceplan.front-end-asp
  back-end-app_service_plan_id = module.appserviceplan.back-end-asp
  front-end-subnet_id = module.networking.front-end-subnet 
  back-end-subnet_id  = module.networking.back-end-subnet
  insights-instrumentation_key = module.appinsights.instrumentation_key 
  environment         = var.environment
  depends_on = [
    module.resource_group.id
  ]
} 

# Disabled - this takes 20 minutes to come up. 
/*
 module "redis" {
   source = "./modules/redis"
   resource_group_name = module.resource_group.resource_group_name 
   location            = var.location
   environment         = var.environment
   subnet_id           = module.networking.redis-subnet
   depends_on          = [ module.networking ]
 }
*/

module "database" {
  source = "./modules/database"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  subnet_id           = module.networking.back-end-subnet
  environment         = var.environment
  valult-id           = module.keyvault.fg-keyvault-id
  depends_on = [
    module.keyvault.fg-keyvault,module.keyvault.kv_access_policy_01
  ]
}


output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "frontend_url" {
  value = module.compute.frontend_url
}

output "backend_url" {
  value = module.compute.backend_url
}

output "keyvault_id" {
  value = module.keyvault.fg-keyvault-id
}


output "appserviceplan_id" {
  value = module.appserviceplan.front-end-asp
}

output "backend_appserviceplan_id" {
  value = module.appserviceplan.back-end-asp
} 

output "subnet_id" {
  value = module.networking.front-end-subnet
} 

output "backend_subnet_id" {
  value = module.networking.back-end-subnet
}

output "redis_subnet_id" {
  value = module.networking.redis-subnet
} 
