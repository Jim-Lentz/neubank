data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "fg-keyvault" {
  name                        = "${var.environment}-fgkeyvault2024"
  location                    = var.location #azurerm_resource_group.rg.location
  resource_group_name         = var.resource_group_name #azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"


}

resource "azurerm_key_vault_access_policy" "kv_access_policy_01" {
  #This policy adds databaseadmin group with below permissions
  key_vault_id       = azurerm_key_vault.fg-keyvault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  key_permissions    = ["Get", "List", "Update", "Delete", "Purge"]
  secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]

  depends_on = [azurerm_key_vault.fg-keyvault]
}

output "fg-keyvault-id" {
  value = azurerm_key_vault.fg-keyvault.id
}

output "fg-keyvault-name" {
  value = azurerm_key_vault.fg-keyvault.name
}
