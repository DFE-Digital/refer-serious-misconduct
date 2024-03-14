# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Eligibility screener", type: :system do
  include CommonSteps

  scenario "User completes eligibility screener as employer" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active
    and_i_am_signed_in
    when_i_visit_the_service

    then_i_can_complete_the_screener_as_an_employer
    and_i_have_started_an_employer_referral
    and_event_tracking_is_working
  end

  private

  def then_i_can_complete_the_screener_as_an_employer
    find("label", text: "I’m referring as an employer").click
    click_on "Continue"

    find("label", text: "Yes").click
    click_on "Continue"

    2.times do
      find("label", text: "I’m not sure").click
      click_on "Continue"
    end

    expect(
      page
    ).to have_content "What will happen after you refer the teacher for serious misconduct"
    click_on "I understand and want to continue"
    expect(page).to have_content "Your referral"
  end

  def and_i_have_started_an_employer_referral
    referral = @user.latest_referral

    expect(page).to have_current_path edit_referral_path(referral)
    expect(referral).to be_from_employer
  end
end
