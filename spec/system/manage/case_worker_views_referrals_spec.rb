# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  before do
    create_list(:referral, 30, :submitted)
    create_list(:referral, 20)
  end

  scenario "Case worker with permissions views referrals" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active

    when_i_am_authorized_as_a_case_worker_with_management_permissions
    when_i_visit_the_referrals_page

    then_i_can_see_the_referrals_page
    and_i_can_see_pagination_for_submitted_claims
  end

  scenario "Case worker with basic auth is not authorized to views referrals" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_staff_http_basic_is_active

    when_i_am_authorized_with_basic_auth_as_a_case_worker
    when_i_visit_the_referrals_page

    then_i_am_unauthorized_and_redirected_to_root_path
  end

  scenario "Case worker without manage referrals permissions is not authorized to view referrals" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active

    when_i_am_authorized_as_a_case_worker_without_management_permissions
    when_i_visit_the_referrals_page

    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def when_i_visit_the_referrals_page
    visit manage_interface_referrals_path
  end

  def then_i_can_see_the_referrals_page
    expect(page).to have_content "Referrals (30)"
    expect(page).to have_content "Jane Smith"
    expect(page).to have_content Referral.first.created_at.to_fs(
                   :day_month_year_time
                 )
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
