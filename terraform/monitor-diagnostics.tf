resource "azurerm_monitor_diagnostic_setting" "rsm-keyvault-diagnostics" {
  count                      = local.keyvault_logging_enabled ? 1 : 0
  name                       = "${data.azurerm_key_vault.vault.name}-diagnostics"
  target_resource_id         = data.azurerm_key_vault.vault.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics.id

  enabled_log {
    category = "AuditEvent"
  }


  metric {
    category = "AllMetrics"
    enabled  = local.keyvault_logging_enabled
  }
}
