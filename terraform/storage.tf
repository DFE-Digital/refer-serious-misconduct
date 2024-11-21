resource "azurerm_storage_account" "allegations" {
  name                              = var.allegations_storage_account_name
  resource_group_name               = var.resource_group_name
  location                          = var.region_name
  account_replication_type          = var.environment_name != "production" ? "LRS" : "GRS"
  account_tier                      = "Standard"
  account_kind                      = "StorageV2"
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true
  allow_nested_items_to_be_public   = false

  blob_properties {
    last_access_time_enabled = true

    container_delete_retention_policy {
      days = var.allegations_container_delete_retention_days
    }
  }

  depends_on = [data.azurerm_resource_group.group]
  lifecycle { ignore_changes = [tags] }
}


resource "azurerm_storage_encryption_scope" "allegations-encryption" {
  name               = "microsoftmanaged"
  storage_account_id = azurerm_storage_account.allegations.id
  source             = "Microsoft.Storage"

  infrastructure_encryption_required = true
}


resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.allegations.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "backup" {
  count = var.enable_postgres_backup_storage ? 1 : 0

  name                             = var.database_backup_storage_account_name
  location                         = var.region_name
  resource_group_name              = var.resource_group_name
  account_tier                     = "Standard"
  account_replication_type         = var.environment_name != "production" ? "LRS" : "GRS"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_storage_container" "rsm" {
  count = var.enable_postgres_backup_storage ? 1 : 0

  name                  = "rsm"
  storage_account_name  = azurerm_storage_account.backup[0].name
  container_access_type = "private"
}
