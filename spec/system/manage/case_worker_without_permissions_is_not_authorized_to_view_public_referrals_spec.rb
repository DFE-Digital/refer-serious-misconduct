# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  before do
    create_list(:referral, 30, :submitted)
    create_list(:referral, 20)
  end

  scenario "Case worker without manage referrals permissions is not authorized to view public referrals",
           type: :system do
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
end
