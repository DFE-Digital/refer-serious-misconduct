resource "azurerm_storage_account" "allegations" {
  name                              = var.allegations_storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.region_name
  account_replication_type          = var.environment_name != "production" ? "LRS" : "GRS"
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true

  blob_properties {
    last_access_time_enabled = true

    container_delete_retention_policy {
      days = var.allegations_container_delete_retention_days
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "azurerm_storage_encryption_scope" "allegations-encryption" {
  name               = "microsoftmanaged"
  storage_account_id = azurerm_storage_account.allegations.id
  source             = "Microsoft.Storage"
}


resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.allegations.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
