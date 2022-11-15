resource "azurerm_resource_group" "review_app_rg" {
  count    = var.create_env_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = "West Europe"
}
