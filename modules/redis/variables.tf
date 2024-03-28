variable "resource_group_name" {
  description = "The resource group name"
  type        = string
}

variable "location" {
  description = "The Azure location"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the frontend"
  type        = string
}
