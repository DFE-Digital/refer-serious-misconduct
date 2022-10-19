variable "environment_name" {
  type = string
}

variable "resource_prefix" {
  type    = string
  default = ""
}

variable "app_suffix" {
  type    = string
  default = ""
}

variable "azure_sp_credentials_json" {
  type    = string
  default = null
}

variable "app_service_plan_sku" {
  type    = string
  default = "B1"
}

variable "postgres_flexible_server_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "postgres_flexible_server_storage_mb" {
  type    = number
  default = 32768
}

variable "enable_postgres_high_availability" {
  type    = bool
  default = false
}
variable "key_vault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "redis_service_sku" {
  type    = string
  default = "Basic"
}

variable "redis_service_version" {
  type    = number
  default = 6
}

variable "redis_service_family" {
  type    = string
  default = "C"
}

variable "redis_service_capacity" {
  type    = number
  default = 1
}

variable "application_insights_daily_data_cap_mb" {
  type    = string
  default = "0.033"
}

variable "application_insights_retention_days" {
  type    = number
  default = 30
}

variable "keyvault_logging_enabled" {
  type    = bool
  default = false
}

variable "storage_diagnostics_logging_enabled" {
  type    = bool
  default = false
}

variable "storage_log_categories" {
  type    = list(string)
  default = []
}

variable "log_analytics_sku" {
  type    = string
  default = "PerGB2018"
}

variable "enable_blue_green" {
  type    = bool
  default = false
}

variable "worker_count" {
  description = "It should be set to a multiple of the number of availability zones in the region"
  type        = number
  default     = null
}

variable "statuscake_alerts" {
  type    = map(any)
  default = {}
}

variable "domain" {}

locals {
  hosting_environment          = var.environment_name
  aytp_app_name                = "${var.resource_prefix}aytp-${var.environment_name}${var.app_suffix}-app"
  postgres_server_name         = "${var.resource_prefix}aytp-${var.environment_name}${var.app_suffix}-psql"
  postgres_database_name       = "access_your_teaching_profile_production"
  redis_database_name          = "${var.resource_prefix}aytp-${var.environment_name}${var.app_suffix}-redis"
  app_insights_name            = "${var.resource_prefix}aytp-${var.environment_name}${var.app_suffix}-appi"
  log_analytics_workspace_name = "${var.resource_prefix}aytp-${var.environment_name}-log"
  app_service_plan_name        = "${var.resource_prefix}aytp-${var.environment_name}-plan"

  keyvault_logging_enabled            = var.keyvault_logging_enabled
  storage_diagnostics_logging_enabled = length(var.storage_log_categories) > 0
  storage_log_categories              = var.storage_log_categories
  storage_log_retention_days          = var.environment_name == "prd" ? 365 : 30
  web_app_slot_name                   = "staging"
}
