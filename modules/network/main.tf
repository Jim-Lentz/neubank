provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_configs
  name                 = "${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]
}

# Frontend NSG and Rule
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "frontend_rule" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.frontend_port
  source_address_prefix       = "Internet"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.frontend_nsg.name
}

# Backend NSG and Rule for access from the frontend subnet
resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "backend_rule" {
  name                        = "allow-from-frontend"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.backend_port
  source_address_prefix       = var.subnet_configs["frontend"].prefix
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.backend_nsg.name
}

# Database NSG and Rule for access from the backend subnet
resource "azurerm_network_security_group" "database_nsg" {
  name                = "database-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "database_rule" {
  name                        = "allow-from-backend"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" # Specify your database port(s) here, e.g., "1433" for SQL Server
  source_address_prefix       = var.subnet_configs["backend"].prefix
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.database_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "frontend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet["frontend"].id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet["backend"].id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "database_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet["database"].id
  network_security_group_id = azurerm_network_security_group.database_nsg.id
}

output "frontend_subnet_id" {
  value = azurerm_subnet.subnet["frontend"].id
}