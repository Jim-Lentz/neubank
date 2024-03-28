resource "azurerm_redis_cache" "cache" {
  name                = "rediscache-mywebapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  # requires premium SKU subnet_id = var.subnet_id

  redis_configuration {}
}

output "redis_cache_hostname" {
  value = azurerm_redis_cache.cache.hostname
}