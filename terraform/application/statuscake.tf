module "statuscake" {
  count = var.enable_monitoring ? 1 : 0

  source = "./vendor/modules/aks//monitoring/statuscake"

  uptime_urls = compact([module.web_application.probe_url, "https://${local.external_domain}/health"])
  ssl_urls    = compact(["https://${local.external_domain}/"])

  contact_groups = var.statuscake_contact_groups
}
