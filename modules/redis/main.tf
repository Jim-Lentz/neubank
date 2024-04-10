# Redis Cache deployed into it's own subnet due to Azure restrictions
# There is an NSG restricting access from only the backend subnet
resource "azurerm_redis_cache" "cache" {
  name                = "rediscache-mywebapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 1
  family              = "P"
  sku_name            = "Premium"
  enable_non_ssl_port = false
  subnet_id           = var.subnet_id
  # requires premium SKU subnet_id = var.subnet_id

  redis_configuration {}

  tags = {
    Environment = var.environment
    Owner = "first.last@company.com"
    Project = "Mortgage Calculator"
  }
}

output "redis_cache_hostname" {
  value = azurerm_redis_cache.cache.hostname
}

output "id" {
  value = azurerm_redis_cache.cache.id
}