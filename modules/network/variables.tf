
variable "location" {
  description = "The Azure location where resources will be created."
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  default     = "dev-rgp-cis-neubank-use-001"
}

variable "vnet_address_space" {
  description = "The address space for the VNet."
  default     = "10.0.0.0/16"
}

variable "subnet_configs" {
  description = "Configuration for each subnet including name and address prefix."
  type        = map(object({ prefix: string }))
  default = {
    frontend = { prefix = "10.0.1.0/24" },
    backend  = { prefix = "10.0.2.0/24" },
    database = { prefix = "10.0.3.0/24" }
  }
}

variable "frontend_port" {
  description = "The network port for frontend access."
  default     = "80"
}

variable "backend_port" {
  description = "The network port for backend access."
  default     = "8080"
}