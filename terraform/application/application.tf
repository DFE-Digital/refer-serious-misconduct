module "application_configuration" {
  source = "./vendor/modules/aks//aks/application_configuration"

  namespace              = var.namespace
  environment            = var.environment
  azure_resource_prefix  = var.azure_resource_prefix
  service_short          = var.service_short
  config_short           = var.config_short
  secret_key_vault_short = "app"

  is_rails_application = true

  config_variables = {
    ENVIRONMENT_NAME           = var.environment
    PGSSLMODE                  = local.postgres_ssl_mode
    HOSTING_DOMAIN             = "https://${local.external_domain}"
    HOSTING_ENVIRONMENT_NAME   = var.environment
    AZURE_STORAGE_ACCOUNT_NAME = azurerm_storage_account.allegations.name,
    AZURE_STORAGE_CONTAINER    = azurerm_storage_container.uploads.name
    GROVER_NO_SANDBOX          = "true"
    PUPPETEER_EXECUTABLE_PATH  = "/usr/bin/chromium-browser"
    BIGQUERY_DATASET           = var.dataset_name
    BIGQUERY_PROJECT_ID        = "refer-serious-misconduct"
    BIGQUERY_TABLE_NAME        = "events"
  }
  secret_variables = merge({
    DATABASE_URL             = module.postgres.url
    REDIS_URL                = module.redis-cache.url
    AZURE_STORAGE_ACCESS_KEY = azurerm_storage_account.allegations.primary_access_key
  }, local.federated_auth_secrets)
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
  replicas     = var.app_replicas
  enable_logit = var.enable_logit
  command      = var.webapp_startup_command

  send_traffic_to_maintenance_page = var.send_traffic_to_maintenance_page

  run_as_non_root = true
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
  enable_logit               = var.enable_logit
  enable_gcp_wif             = true

  run_as_non_root = true
}
