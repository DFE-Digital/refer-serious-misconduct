# frozen_string_literal: true
require "spec_helper"
require "capybara/rspec"
require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.always_include_port = false

TEST_ENVIRONMENTS = "local dev test preprod review"

RSpec.describe "Smoke test", type: :system, js: true, smoke_test: true do
  it "works as expected" do
    given_i_am_authorized_as_a_support_user
    when_i_visit_the_service
    then_it_loads_successfully
  end

  it "/health/all returns 200" do
    page.visit("#{ENV["HOSTING_DOMAIN"]}/health/all")
    expect(page.status_code).to eq(200)
  end

  private

  def given_i_am_authorized_as_a_support_user
    page.driver.basic_authorize(ENV["SUPPORT_USERNAME"], ENV["SUPPORT_PASSWORD"])
  end

  def when_i_visit_the_service
    page.visit("#{ENV["HOSTING_DOMAIN"]}/start")
  end

  def then_it_loads_successfully
    if TEST_ENVIRONMENTS.include?(hosting_environment_name)
      expect(page).to have_content("Do you have an account?")
    else
      expect(
        page
      ).to have_content "Are you making a referral as an employer or member of the public?"
    end
  end

  def hosting_environment_name
    ENV.fetch("HOSTING_ENVIRONMENT_NAME", "unknown")
  end
end
