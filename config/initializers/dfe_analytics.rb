DfE::Analytics.configure do |config|
  config.queue = :analytics
  config.environment = HostingEnvironment.environment_name
  config.entity_table_checks_enabled = true

  config.enable_analytics =
    proc do
      disabled_by_default = Rails.env.development?
      ENV.fetch("BIGQUERY_DISABLE", disabled_by_default.to_s) != "true"
    end
  config.azure_federated_auth = ENV.include? "GOOGLE_CLOUD_CREDENTIALS"

  # Perform airbyte checks on startup and allow airbyte config generation.
  # Terraform only sets the dataset where Airbyte is enabled
  config.airbyte_enabled = ENV["BIGQUERY_AIRBYTE_DATASET"].present?
end
