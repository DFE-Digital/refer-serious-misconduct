# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Support", type: :system do
  it "visiting the support interface" do
    given_an_eligibility_check_exists
    when_i_am_authorized_as_a_support_user
    and_i_visit_the_support_page
    then_i_see_the_eligibility_checks_page

    when_i_visit_the_features_page
    then_i_see_the_feature_page
  end

  private

  def and_i_visit_the_support_page
    visit support_interface_root_path
  end

  def given_an_eligibility_check_exists
    EligibilityCheck.create(reporting_as: :employer, serious_misconduct: :yes)
  end

  def then_i_see_the_eligibility_checks_page
    expect(page).to have_current_path(support_interface_eligibility_checks_path)
    expect(page).to have_title("Eligibility Checks - Refer serious misconduct by a teacher")
    expect(page).to have_content("Eligibility Checks")
    expect(page).to have_content("1 of 1")
  end

  def then_i_see_the_feature_page
    expect(page).to have_content("Features")
  end

  def when_i_am_authorized_as_a_support_user
    page.driver.basic_authorize("test", "test")
  end

  def when_i_visit_the_features_page
    visit support_interface_feature_flags_path
  end
end
