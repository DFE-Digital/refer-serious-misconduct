# frozen_string_literal: true
require "spec_helper"
require "capybara/rspec"
require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.always_include_port = false

RSpec.describe "Smoke test", type: :system, js: true, smoke_test: true do
  it "works as expected" do
    given_i_am_authorized_as_a_support_user
    when_i_visit_the_service
    then_i_see_the_start_page
    when_i_visit_the_first_page_of_the_screener
    then_it_loads_successfully
  end

  it "/health/all returns 200" do
    page.visit("#{ENV["HOSTING_DOMAIN"]}/health/all")
    expect(page.status_code).to eq(200)
  end

  private

  def given_i_am_authorized_as_a_support_user
    page.driver.basic_authorize(
      ENV["SUPPORT_USERNAME"],
      ENV["SUPPORT_PASSWORD"]
    )
  end

  def when_i_visit_the_service
    page.visit("#{ENV["HOSTING_DOMAIN"]}/start")
  end

  def then_i_see_the_start_page
    expect(page).to have_link("Start now")
  end

  def when_i_visit_the_first_page_of_the_screener
    page.visit("#{ENV["HOSTING_DOMAIN"]}/who")
  end

  def then_it_loads_successfully
    expect(
      page
    ).to have_content "Are you reporting as an employer or member of the public?"
  end
end
