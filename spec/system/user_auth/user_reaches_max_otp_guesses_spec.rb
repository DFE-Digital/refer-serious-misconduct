# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  include CommonSteps

  scenario "User signs in" do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_the_referral_form_feature_is_active

    when_i_start_the_signin_flow
    and_max_out_my_otp_guesses
    then_i_see_an_error_screen
    and_can_return_to_the_email_screen
    and_my_otp_state_is_reset
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_eligibility_screener_is_enabled
    FeatureFlags::FeatureFlag.activate(:eligibility_screener)
  end

  def and_the_referral_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:referral_form)
  end

  def and_max_out_my_otp_guesses
    Users::OtpForm::MAX_GUESSES.times do
      fill_in "Confirmation code", with: "123456"
      within("main") { click_on "Continue" }
    end
  end

  def then_i_see_an_error_screen
    expect(page).to have_content I18n.t("users.retry.exhausted.heading")
    expect(page).to have_content I18n.t("users.retry.exhausted.body")
  end

  def and_can_return_to_the_email_screen
    click_link "Sign in", href: new_user_session_path
    expect(page).to have_content "Sign in"
  end

  def and_my_otp_state_is_reset
    user = User.last
    expect(user.secret_key).to be_nil
    expect(user.otp_guesses).to eq 0
  end
end
