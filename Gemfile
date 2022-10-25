source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "devise_invitable"
gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "govuk_feature_flags",
    git: "https://github.com/DFE-Digital/govuk_feature_flags.git",
    branch: "main"
gem "govuk_markdown", "~> 1.0"
gem "jsbundling-rails"
gem "mail-notify"
gem "okcomputer", "~> 1.18"
gem "pg", "~> 1.4"
gem "propshaft"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.3"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "view_component"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", "~> 2.8"
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :development do
  gem "annotate", require: false
  gem "prettier_print", require: false
  gem "rladr"
  gem "rubocop-govuk", require: false
  gem "solargraph", require: false
  gem "solargraph-rails", require: false
  gem "syntax_tree", require: false
  gem "syntax_tree-haml", require: false
  gem "syntax_tree-rbs", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "cuprite"
end

group :test do
  gem "rspec"
  gem "shoulda-matchers"
end
