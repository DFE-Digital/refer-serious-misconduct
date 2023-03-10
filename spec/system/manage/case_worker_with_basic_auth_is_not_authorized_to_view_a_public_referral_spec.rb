# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker with basic auth is not authorized to view a public referral",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_staff_http_basic_is_active
    and_i_am_authorized_with_basic_auth_as_a_case_worker
    and_there_is_an_existing_public_referral

    when_i_visit_the_referral
    then_i_am_unauthorized_and_redirected_to_forbidden_path
  end

  private

  def and_there_is_an_existing_public_referral
    @referral = create(:referral, :public_complete)
  end

  def when_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
end
