# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker with permissions views public referrals", type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_referral_forms_exist

    when_i_login_as_a_case_worker_with_management_permissions_only
    when_i_visit_the_referrals_page

    then_i_can_see_the_referrals_page
    and_i_can_see_pagination_for_submitted_claims
  end

  private

  def when_i_visit_the_referrals_page
    visit manage_interface_referrals_path
  end

  def then_i_can_see_the_referrals_page
    expect(page).to have_content "Referrals (30)"
    expect(page).to have_content "Jane Smith"
    expect(page).to have_content Referral.first.created_at.to_fs(:day_month_year_time)
  end

  def and_i_can_see_pagination_for_submitted_claims
    within(".govuk-pagination") do
      expect(page).to have_content "1"
      expect(page).to have_content "2"
      expect(page).not_to have_content "3"
      expect(page).to have_content "Next"
    end
  end
end
