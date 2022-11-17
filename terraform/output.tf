output "app_fqdn" {
  value = var.domain != null ? var.domain : azurerm_linux_web_app.rsm-app.default_hostname
}
output "postgres_server_name" {
  value = azurerm_postgresql_flexible_server.postgres-server.name
}

output "blue_green" {
  value = var.enable_blue_green
}

output "web_app_name" {
  value = azurerm_linux_web_app.rsm-app.name
}

output "worker_app_name" {
  value = azurerm_linux_web_app.rsm-worker-app.name
}

output "web_app_slot_name" {
  value = var.enable_blue_green ? local.web_app_slot_name : "production"
}
