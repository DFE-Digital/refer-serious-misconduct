# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  include CommonSteps

  around { |example| freeze_time { example.run } }

  scenario "User signs in" do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_the_referral_form_feature_is_active

    when_i_start_the_signin_flow
    and_my_otp_has_expired
    when_i_try_to_sign_in
    then_i_see_an_error_screen
    and_can_return_to_the_email_screen
    and_my_otp_state_is_reset
  end

  def and_my_otp_has_expired
    travel_to(Users::OtpForm::EXPIRY_TIME.from_now)
  end

  def when_i_try_to_sign_in
    user = User.find_by(email: "test@example.com")
    expected_otp = Devise::Otp.derive_otp(user.secret_key)
    fill_in "Confirmation code", with: expected_otp
    within("main") { click_on "Continue" }
  end

  def then_i_see_an_error_screen
    expect(page).to have_content I18n.t("users.retry.expired.heading")
    expect(page).to have_content "You need to request a new confirmation code."
  end

  def and_can_return_to_the_email_screen
    click_link "request a new confirmation code"
    expect(page).to have_content "Sign in"
  end

  def and_my_otp_state_is_reset
    user = User.last
    expect(user.secret_key).to be_nil
    expect(user.otp_guesses).to eq 0
  end
end
