locals {
  rsm_env_vars = merge(try(local.infrastructure_secrets, null),
    {
      DOCKER_REGISTRY_SERVER_URL            = "https://ghcr.io",
      ApplicationInsights__ConnectionString = azurerm_application_insights.insights.connection_string
      DATABASE_URL                          = "postgres://postgres@${local.postgres_server_name}.postgres.database.azure.com:5432"
      DATABASE_PASSWORD                     = local.infrastructure_secrets.POSTGRES_ADMIN_PASSWORD
      HOSTING_DOMAIN                        = "https://${var.domain}"
      HOSTING_ENVIRONMENT_NAME              = local.hosting_environment
      RAILS_SERVE_STATIC_FILES              = "true"
      ConnectionStrings__Redis              = azurerm_redis_cache.redis.primary_connection_string
      WEBSITE_SWAP_WARMUP_PING_PATH         = "/health"
      WEBSITE_SWAP_WARMUP_PING_STATUSES     = "200"
      AZURE_STORAGE_ACCOUNT_NAME            = azurerm_storage_account.allegations.name,
      AZURE_STORAGE_ACCESS_KEY              = azurerm_storage_account.allegations.primary_access_key,
      AZURE_STORAGE_CONTAINER               = azurerm_storage_container.uploads.name
      REDIS_URL                             = azurerm_redis_cache.redis.primary_connection_string
    }
  )
}

resource "azurerm_postgresql_flexible_server" "postgres-server" {
  name                   = local.postgres_server_name
  location               = data.azurerm_resource_group.group.location
  resource_group_name    = data.azurerm_resource_group.group.name
  version                = 14
  administrator_login    = local.infrastructure_secrets.POSTGRES_ADMIN_USERNAME
  administrator_password = local.infrastructure_secrets.POSTGRES_ADMIN_PASSWORD
  create_mode            = "Default"
  storage_mb             = var.postgres_flexible_server_storage_mb
  sku_name               = var.postgres_flexible_server_sku
  dynamic "high_availability" {
    for_each = var.enable_postgres_high_availability ? [1] : []
    content {
      mode = "ZoneRedundant"
    }
  }
  lifecycle {
    ignore_changes = [
      tags,
      # Allow Azure to manage deployment zone. Ignore changes.
      zone,
      # Allow Azure to manage primary and standby server on fail-over. Ignore changes.
      high_availability[0].standby_availability_zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "postgres-database" {
  name      = local.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.postgres-server.id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgres-fw-rule-azure" {
  name             = "AllowAzure"
  server_id        = azurerm_postgresql_flexible_server.postgres-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_redis_cache" "redis" {
  name                = local.redis_database_name
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  capacity            = var.redis_service_capacity
  family              = var.redis_service_family
  sku_name            = var.redis_service_sku
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  redis_version       = var.redis_service_version

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_log_analytics_workspace" "analytics" {
  name                = local.log_analytics_workspace_name
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  sku                 = var.log_analytics_sku
  retention_in_days   = local.storage_log_retention_days

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_application_insights" "insights" {
  name                 = local.app_insights_name
  location             = data.azurerm_resource_group.group.location
  resource_group_name  = data.azurerm_resource_group.group.name
  application_type     = "web"
  daily_data_cap_in_gb = var.application_insights_daily_data_cap_mb
  retention_in_days    = var.application_insights_retention_days

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_service_plan" "service-plan" {
  name                   = local.app_service_plan_name
  location               = data.azurerm_resource_group.group.location
  resource_group_name    = data.azurerm_resource_group.group.name
  os_type                = "Linux"
  sku_name               = var.app_service_plan_sku
  zone_balancing_enabled = var.worker_count != null ? true : false
  worker_count           = var.worker_count
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_linux_web_app" "rsm-app" {
  name                = local.rsm_app_name
  location            = data.azurerm_resource_group.group.location
  resource_group_name = data.azurerm_resource_group.group.name
  service_plan_id     = azurerm_service_plan.service-plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    http2_enabled       = true
    minimum_tls_version = "1.2"
    health_check_path   = "/health"
    ip_restriction = var.domain != null ? [{
      name     = "FrontDoor"
      action   = "Allow"
      priority = 1
      headers = [{
        x_azure_fdid      = try([local.infrastructure_secrets.FRONTDOOR_ID],[])
        x_fd_health_probe = []
        x_forwarded_for   = []
        x_forwarded_host  = []
      }]
      service_tag               = "AzureFrontDoor.Backend"
      ip_address                = null
      virtual_network_subnet_id = null
    }] : []
  }

  app_settings = local.rsm_env_vars

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_linux_web_app_slot" "rsm-stage" {
  count          = var.enable_blue_green ? 1 : 0
  name           = local.web_app_slot_name
  app_service_id = azurerm_linux_web_app.rsm-app.id
  site_config {
    http2_enabled       = true
    minimum_tls_version = "1.2"
    health_check_path   = "/health"
  }
  app_settings = local.rsm_env_vars
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
