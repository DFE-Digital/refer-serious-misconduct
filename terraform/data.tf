data "azurerm_resource_group" "group" {
  name = var.environment_name == "review" ? azurerm_resource_group.review_app_rg[0].name : var.resource_group_name
}

data "azurerm_resource_group" "keyvault_group" {
  name = var.environment_name == "review" ? var.key_vault_resource_group : var.resource_group_name
}

data "azurerm_key_vault" "vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.keyvault_group.name
}

data "azurerm_key_vault_secrets" "secrets" {
  key_vault_id = data.azurerm_key_vault.vault.id
}

data "azurerm_key_vault_secret" "secrets" {
  key_vault_id = data.azurerm_key_vault.vault.id
  for_each     = toset(data.azurerm_key_vault_secrets.secrets.names)
  name         = each.key
}
