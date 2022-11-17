# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  scenario "User signs in" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active

    when_i_start_the_signin_flow
    and_max_out_my_otp_guesses
    then_i_am_sent_back_to_the_email_screen_with_an_error
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
  end

  def when_i_start_the_signin_flow
    visit root_path
    click_on "Start now"
    fill_in "Enter your email address", with: "test@example.com"
    click_on "Send code"
  end

  def and_max_out_my_otp_guesses
    Users::OtpForm::MAX_GUESSES.times do
      fill_in "Enter your code", with: "123456"
      within("main") { click_on "Sign in" }
    end
  end

  def then_i_am_sent_back_to_the_email_screen_with_an_error
    expect(page).to have_content "Enter your email address"
    expect(page).to have_content "Please try signing in again"
  end

  def and_my_otp_state_is_reset
    user = User.last
    expect(user.secret_key).to be_nil
    expect(user.otp_guesses).to be_nil
  end
end
