# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Support" do
  include CommonSteps

  scenario "a staff user with permissions can visit the support interface",
           type: :system do
    given_the_service_is_open
    given_an_eligibility_check_exists
    and_the_eligibility_screener_is_enabled
    when_i_login_as_a_case_worker_with_support_permissions_only
    then_i_see_the_staff_index
    and_i_visit_the_support_page
    then_i_see_the_eligibility_checks_page
    and_i_do_not_see_referrals_link

    when_i_visit_the_features_page
    then_i_see_the_feature_page
  end

  private

  def and_i_visit_the_support_page
    visit support_interface_root_path
  end

  def and_i_do_not_see_referrals_link
    expect(page).not_to have_link("Referrals")
  end

  def given_an_eligibility_check_exists
    EligibilityCheck.create(reporting_as: :employer, serious_misconduct: :yes)
  end

  def then_i_see_the_eligibility_checks_page
    expect(page).to have_current_path(support_interface_eligibility_checks_path)
    expect(page).to have_title(
      "Eligibility Checks - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content("Eligibility Checks")
    expect(page).to have_content("1 of 1")
  end

  def then_i_see_the_feature_page
    expect(page).to have_content("Features")
  end

  def when_i_visit_the_features_page
    visit support_interface_feature_flags_path
  end
end
