# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  around { |example| Timecop.freeze { example.run } }

  scenario "User signs in" do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active

    when_i_start_the_signin_flow
    and_my_otp_has_expired
    when_i_try_to_sign_in
    then_i_am_sent_back_to_the_email_screen_with_an_error
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_eligibility_screener_is_enabled
    FeatureFlags::FeatureFlag.activate(:eligibility_screener)
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

  def and_my_otp_has_expired
    Timecop.travel(Users::OtpForm::EXPIRY_IN_MINUTES.from_now)
  end

  def when_i_try_to_sign_in
    user = User.find_by(email: "test@example.com")
    expected_otp = Devise::Otp.derive_otp(user.secret_key)
    fill_in "Enter your code", with: expected_otp
    within("main") { click_on "Sign in" }
  end

  def then_i_am_sent_back_to_the_email_screen_with_an_error
    expect(page).to have_content "Enter your email address"
    expect(page).to have_content("Security code has expired. Try again.")
  end
end
