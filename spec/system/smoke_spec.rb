# frozen_string_literal: true
require "spec_helper"
require "capybara/rspec"
require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.always_include_port = false

TEST_ENVIRONMENTS = "local dev test preprod review"

RSpec.describe "Smoke test", type: :system, js: true, smoke_test: true do
  it "works as expected" do
    when_i_visit_the_service
    then_it_loads_successfully
  end

  it "/health/all returns 200" do
    page.visit("#{hosting_authenticated_url}/health/all")
    expect(page.status_code).to eq(200)
  end

  private

  def when_i_visit_the_service
    page.visit("#{hosting_authenticated_url}/start")
  end

  def then_it_loads_successfully
    if TEST_ENVIRONMENTS.include?(hosting_environment_name)
      expect(page).to have_content("Have you used this service before?")
    else
      expect(
        page
      ).to have_content "Are you making a referral as an employer or member of the public?"
    end
  end

  def hosting_environment_name
    ENV.fetch("HOSTING_ENVIRONMENT_NAME", "unknown")
  end

  def hosting_authenticated_url
    url = ENV["HOSTING_DOMAIN"].dup
    username = ENV["SUPPORT_USERNAME"]
    password = ENV["SUPPORT_PASSWORD"]

    url.insert(8, "#{username}:#{password}@")
  end
end
