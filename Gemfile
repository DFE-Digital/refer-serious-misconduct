source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "azure-storage-blob"
gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "devise_invitable"
gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "govuk_feature_flags",
    git: "https://github.com/DFE-Digital/govuk_feature_flags.git",
    tag: "v1.0.0"
gem "govuk_markdown", "~> 1.0"
gem "jsbundling-rails"
gem "logstop"
gem "mail-notify"
gem "okcomputer", "~> 1.18"
gem "pagy"
gem "pg", "~> 1.4"
gem "propshaft"
gem "puma", "~> 6.1"
gem "pundit", "~> 2.3"
gem "rails", "~> 7.0.4"
gem "rotp"
gem "rubyzip"
gem "sentry-rails"
gem "sidekiq", "< 7"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uk_postcode"

group :development, :test do
  gem "dotenv-rails", "~> 2.8"
  gem "factory_bot_rails"
  gem "launchy"
  gem "pry"
  gem "pry-nav"
  gem "rspec-rails"
end

group :development do
  gem "prettier_print", require: false
  gem "rladr"
  gem "rubocop-govuk", require: false
  gem "solargraph-rails", require: false
  gem "syntax_tree", require: false
  gem "syntax_tree-haml", require: false
  gem "syntax_tree-rbs", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "rspec"
  gem "shoulda-matchers"
end
