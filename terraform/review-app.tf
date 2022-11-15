resource "azurerm_resource_group" "review_app_rg" {
  count    = var.environment_name == "review" ? 1 : 0
  name     = var.resource_group_name
  location = "West Europe"
}
