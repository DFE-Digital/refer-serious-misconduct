require "rails_helper"

RSpec.feature "Eligibility screener", type: :system do
  scenario "happy path" do
    given_the_service_is_open
    when_the_screener_is_disabled
    when_i_visit_the_service
    then_i_see_the_govuk_page

    when_the_screener_is_enabled
    when_i_visit_the_service
    then_i_see_the_start_page
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_see_the_govuk_page
    expect(page).to have_current_path("https://www.gov.uk/government/publications/teacher-misconduct-referral-form")
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/referral-type")
  end

  def when_i_visit_the_service
    visit root_path
  end

  def when_the_screener_is_disabled
    FeatureFlags::FeatureFlag.deactivate(:eligibility_screener)
  end

  def when_the_screener_is_enabled
    FeatureFlags::FeatureFlag.activate(:eligibility_screener)
  end
end
