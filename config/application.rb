require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

require "./app/lib/hosting_environment"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReferSeriousMisconduct
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq

    config.assets.paths << Rails.root.join("node_modules/govuk-frontend/dist/govuk/assets")

    config.exceptions_app = routes

    config.action_mailer.notify_settings = {
      api_key:
        ENV.fetch("GOVUK_NOTIFY_API_KEY") do
          raise "'GOVUK_NOTIFY_API_KEY' should be configured in " \
                  ".env.*environment* file. Please refer to " \
                  "https://github.com/DFE-Digital/refer-serious-misconduct/#notify"
        end
    }
  end
end
