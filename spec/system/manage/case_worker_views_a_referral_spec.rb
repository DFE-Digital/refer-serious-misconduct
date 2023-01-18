# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker views a referral" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_staff_http_basic_is_active
    and_i_am_authorized_as_a_case_worker
    and_there_is_an_existing_referral

    when_i_visit_the_referral
    then_i_see_the_referral
  end

  private

  def and_i_am_authorized_as_a_case_worker
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end

  def and_there_is_an_existing_referral
    create(:referral, :complete)
  end

  def then_i_see_the_referral
    expect(page).to have_content(Referral.last.id)
    expect(page).to have_content(Referral.last.referrer_name)
  end

  def when_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
end
