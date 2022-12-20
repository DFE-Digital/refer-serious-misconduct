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

    when_i_press_start
    then_i_can_complete_the_screener_as_an_employer
    and_i_have_started_an_employer_referral
  end

  private

  def when_i_press_start
    click_on "Start now"
  end

  def then_i_can_complete_the_screener_as_an_employer
    choose "I’m referring as an employer", visible: false
    click_on "Continue"

    4.times do
      choose "I’m not sure", visible: false
      click_on "Continue"
    end

    expect(page).to have_content "What completing this referral means for you"
    click_on "Continue"
    expect(page).to have_content "Your progress is saved as you go"
    click_on "Continue"
  end

  def and_i_have_started_an_employer_referral
    referral = @user.latest_referral

    expect(page).to have_current_path edit_referral_path(referral)
    expect(referral).to be_from_employer
  end
end
