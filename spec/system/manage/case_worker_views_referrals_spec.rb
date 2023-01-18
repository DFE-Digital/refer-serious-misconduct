# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  before do
    travel_to Time.zone.local(2022, 11, 22, 12, 0, 0)
    create_list(:referral, 30, :complete)
  end

  scenario "Case worker views referrals" do
    given_the_service_is_open
    and_staff_http_basic_is_active
    when_i_am_authorized_as_a_staff_user

    and_i_visit_the_referrals_page
    then_i_can_see_the_referrals_page
  end

  private

  def when_i_am_authorized_as_a_staff_user
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end

  def and_i_visit_the_referrals_page
    visit support_interface_root_path
    click_link "Referrals"
  end

  def then_i_can_see_the_referrals_page
    expect(page).to have_content "Referrals (30)"
    expect(page).to have_content "MyString"
    expect(page).to have_content "22 November 2022 at 12:00 pm"

    within(".govuk-pagination") do
      expect(page).to have_content "1"
      expect(page).to have_content "2"
      expect(page).not_to have_content "3"
      expect(page).to have_content "Next"
    end
  end
end
