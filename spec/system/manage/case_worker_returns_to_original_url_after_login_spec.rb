# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals and staff" do
  include CommonSteps

  scenario "Case worker returns to the original path after login" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_there_is_an_existing_public_referral
    and_there_is_a_case_worker_with_permissions
    and_i_visit_the_referral

    and_i_login_as_a_case_worker_with_management_permissions_only
    then_i_see_the_referral_summary

    when_i_sign_out
    and_i_login_as_a_case_worker_with_management_permissions_only
    then_i_see_manage_referrals_page
  end

  private

  def and_there_is_an_existing_public_referral
    create(:referral, :public_complete)
  end

  def and_there_is_a_case_worker_with_permissions
    create(:staff, :confirmed, :can_manage_referrals)
  end

  def then_i_see_the_referral_summary
    expect(page).to have_content("Summary")
    within("#summary") do
      expect(page).to have_content(Referral.last.id)
      expect(page).to have_content(Referral.last.created_at.to_fs(:day_month_year_time))
    end
  end

  def when_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
  alias_method :and_i_visit_the_referral, :when_i_visit_the_referral

  def and_i_login_as_a_case_worker_with_management_permissions_only
    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end

  def when_i_sign_out
    within(".govuk-header") { click_on "Sign out" }
  end
end
