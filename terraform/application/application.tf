module "application_configuration" {
  source = "./vendor/modules/aks//aks/application_configuration"

  namespace              = var.namespace
  environment            = var.environment
  azure_resource_prefix  = var.azure_resource_prefix
  service_short          = var.service_short
  config_short           = var.config_short
  secret_key_vault_short = "app"

  # Delete for non rails apps
  is_rails_application = true

  config_variables = {
    ENVIRONMENT_NAME           = var.environment
    PGSSLMODE                  = local.postgres_ssl_mode
    HOSTING_DOMAIN             = "refer-serious-misconduct-pr-1234.test.teacherservices.cloud" # var.domain != null ? "https://${var.domain}" : "https://${local.rsm_web_app_name}.azurewebsites.net"
    HOSTING_ENVIRONMENT_NAME   = var.environment                                               # local.hosting_environment
    RAILS_SERVE_STATIC_FILES   = "true"
    AZURE_STORAGE_ACCOUNT_NAME = azurerm_storage_account.allegations.name,
    AZURE_STORAGE_CONTAINER    = azurerm_storage_container.uploads.name
    GROVER_NO_SANDBOX          = "true"
    PUPPETEER_EXECUTABLE_PATH  = "/usr/bin/chromium-browser"
  }
  secret_variables = {
    DATABASE_URL             = module.postgres.url
    REDIS_URL                = module.redis-cache.url
    AZURE_STORAGE_ACCESS_KEY = azurerm_storage_account.allegations.primary_access_key
  }
}

module "web_application" {
  source = "./vendor/modules/aks//aks/application"

  is_web = true

  namespace    = var.namespace
  environment  = var.environment
  service_name = var.service_name
  probe_path   = "/health"

  cluster_configuration_map  = module.cluster_data.configuration_map
  kubernetes_config_map_name = module.application_configuration.kubernetes_config_map_name
  kubernetes_secret_name     = module.application_configuration.kubernetes_secret_name

  docker_image = var.docker_image

  send_traffic_to_maintenance_page = var.send_traffic_to_maintenance_page
}

module "main_worker" {
  source     = "./vendor/modules/aks//aks/application"
  depends_on = [module.web_application]

  namespace                  = var.namespace
  environment                = var.environment
  service_name               = var.service_name
  name                       = "worker"
  is_web                     = false
  docker_image               = var.docker_image
  replicas                   = var.worker_replicas
  max_memory                 = var.worker_memory_max
  cluster_configuration_map  = module.cluster_data.configuration_map
  kubernetes_config_map_name = module.application_configuration.kubernetes_config_map_name
  kubernetes_secret_name     = module.application_configuration.kubernetes_secret_name
  command                    = ["/bin/sh", "-c", "bundle exec sidekiq -C config/sidekiq.yml"]
  probe_command              = ["pgrep", "-f", "sidekiq"]
  enable_gcp_wif             = true
}
