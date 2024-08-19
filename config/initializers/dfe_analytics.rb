DfE::Analytics.configure do |config|
  config.queue = :analytics
  config.environment = HostingEnvironment.environment_name
  config.entity_table_checks_enabled = true

  config.enable_analytics =
    proc do
      disabled_by_default = Rails.env.development?
      ENV.fetch("BIGQUERY_DISABLE", disabled_by_default.to_s) != "true"
    end

  config.bigquery_maintenance_window = "19-08-2024 18:00..19-08-2024 19:00"
end
