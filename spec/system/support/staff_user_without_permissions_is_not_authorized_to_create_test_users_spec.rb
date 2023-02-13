# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Test users" do
  include CommonSteps

  scenario "Staff user without permissions is not authorized to create test users",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    when_i_am_authorized_as_a_case_worker_without_support_permissions

    and_i_visit_the_test_users_section
    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def and_i_visit_the_test_users_section
    visit support_interface_root_path
  end
end
