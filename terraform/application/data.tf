#Do we need it? We have already created one during initial setup.
data "azurerm_resource_group" "group" {
  name = var.environment == "review" ? azurerm_resource_group.review_app_rg[0].name : var.resource_group_name
}
