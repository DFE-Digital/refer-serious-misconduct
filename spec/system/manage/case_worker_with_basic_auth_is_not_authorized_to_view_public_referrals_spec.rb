# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker with basic auth is not authorized to view public referrals",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_staff_http_basic_is_active
    and_referral_forms_exist

    when_i_am_authorized_with_basic_auth_as_a_case_worker
    when_i_visit_the_referrals_page

    then_i_am_unauthorized_and_redirected_to_forbidden_path
  end

  private

  def when_i_visit_the_referrals_page
    visit manage_interface_referrals_path
  end
end
