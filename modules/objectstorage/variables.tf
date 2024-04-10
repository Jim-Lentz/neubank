variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "environment" {
  description = "Dev, Test, Prod"
  type        = string
}
variable "frontend_subnet_id" {
  type        = string
}

variable "backend_subnet_id" {
  type        = string
}
