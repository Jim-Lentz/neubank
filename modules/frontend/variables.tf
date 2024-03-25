variable "name" {
  description = "The name of the frontend app service"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "app_service_plan_id" {
  description = "The App Service Plan ID for the frontend app"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the frontend"
  type        = string
}