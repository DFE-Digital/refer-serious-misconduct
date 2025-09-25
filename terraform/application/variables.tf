variable "app_replicas" {
  type        = number
  description = "Number of replicas of the web app"
  default     = 1
}
variable "cluster" {
  description = "AKS cluster where this app is deployed. Either 'test' or 'production'"
}
variable "namespace" {
  description = "AKS namespace where this app is deployed"
}
variable "environment" {
  description = "Name of the deployed environment in AKS"
}
variable "azure_resource_prefix" {
  description = "Standard resource prefix. Usually s189t01 (test) or s189p01 (production)"
}
variable "azure_maintenance_window" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })
  default = null
}
variable "config" {
  description = "Long name of the environment configuration, e.g. review, development, production..."
}
variable "config_short" {
  description = "Short name of the environment configuration, e.g. dv, st, pd..."
}
variable "service_name" {
  description = "Full name of the service. Lowercase and hyphen separated"
}
variable "service_short" {
  description = "Short name to identify the service. Up to 6 charcters."
}
variable "deploy_azure_backing_services" {
  default     = true
  description = "Deploy real Azure backing services like databases, as opposed to containers inside of AKS"
}
variable "enable_postgres_ssl" {
  default     = true
  description = "Enforce SSL connection from the client side"
}
variable "postgres_flexible_server_sku" {
  type    = string
  default = "B_Standard_B1ms"
}
variable "postgres_enable_high_availability" {
  type    = bool
  default = false
}
variable "enable_postgres_backup_storage" {
  default     = false
  description = "Create a storage account to store database dumps"
}
variable "docker_image" {
  description = "Docker image full name to identify it in the registry. Includes docker registry, repository and tag e.g.: ghcr.io/dfe-digital/teacher-pay-calculator:673f6309fd0c907014f44d6732496ecd92a2bcd0"
}
variable "external_url" {
  default     = null
  description = "Healthcheck URL for StatusCake monitoring"
}
variable "statuscake_contact_groups" {
  default     = []
  description = "ID of the contact group in statuscake web UI"
}
variable "enable_logit" {
  type    = bool
  default = false
}
variable "enable_monitoring" {
  default     = false
  description = "Enable monitoring and alerting"
}
variable "send_traffic_to_maintenance_page" {
  default     = false
  description = "During a maintenance operation, keep sending traffic to the maintenance page instead of resetting the ingress"
}
variable "account_replication_type" {
  description = "Replication LRS (across AZs) or GRS (across regions)"
  default     = "LRS"
}
variable "resource_group_name" {
  type = string
}
variable "allegations_storage_account_name" {
  default = null
}
variable "allegations_container_delete_retention_days" {
  default = 7
  type    = number
}
variable "worker_memory_max" {
  default = "1Gi"
}
variable "worker_replicas" {
  default = 1
}
variable "webapp_startup_command" {
  default     = null
  description = "Override Dockerfile startup command"
}

variable "enable_dfe_analytics_federated_auth" {
  description = "Create the resources in Google cloud for federated authentication and enable in application"
  default     = false
}

variable "dataset_name" {
  description = "dfe analytics dataset name in Google Bigquery"
  default     = null
}

locals {
  postgres_ssl_mode                = var.enable_postgres_ssl ? "require" : "disable"
  storage_account_environment      = var.config == var.environment ? var.config_short : replace(var.environment, "-", "")
  allegations_storage_account_name = "${var.azure_resource_prefix}rsmalleg${local.storage_account_environment}sa"

  environment_variables = yamldecode(file("${path.module}/config/${var.config}.yml"))
  ingress_domain        = "${var.service_name}-${var.environment}.${module.cluster_data.ingress_domain}"
  external_domain       = try(local.environment_variables["EXTERNAL_DOMAIN"], local.ingress_domain)

  federated_auth_secrets = var.enable_dfe_analytics_federated_auth ? {
    GOOGLE_CLOUD_CREDENTIALS = module.dfe_analytics[0].google_cloud_credentials
  } : {}
}
