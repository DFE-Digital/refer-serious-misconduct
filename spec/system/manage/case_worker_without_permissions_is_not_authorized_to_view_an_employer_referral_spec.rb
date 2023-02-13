# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker without manage_referrals permission is not authorized to view an employer referral",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_there_is_an_existing_employer_referral

    when_i_am_authorized_as_a_case_worker_without_management_permissions
    and_i_visit_the_referral
    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def and_there_is_an_existing_employer_referral
    @referral = create(:referral, :employer_complete)
  end

  def and_i_visit_the_referral
    visit manage_interface_referral_path(Referral.last)
  end
end
