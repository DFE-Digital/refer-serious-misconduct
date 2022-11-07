# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  scenario "User signs in" do
    given_the_service_is_open
    when_i_visit_the_root_page
    and_click_start_now
    and_i_submit_my_email
    when_i_provide_the_wrong_otp
    then_i_see_an_error
    when_i_submit_my_email
    and_i_provide_the_expected_otp
    then_i_am_signed_in
    and_i_am_not_prompted_to_sign_in_again
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def when_i_visit_the_root_page
    visit root_path
  end

  def and_click_start_now
    click_on "Start now"
  end

  def and_i_submit_my_email
    fill_in "Enter your email address", with: "test@example.com"
    click_on "Send code"
  end
  alias_method :when_i_submit_my_email, :and_i_submit_my_email

  def when_i_provide_the_wrong_otp
    fill_in "Enter your code", with: "wrong_value"
    within("main") { click_on "Sign in" }
  end

  def then_i_see_an_error
    expect(page).to have_content "Invalid code"
  end

  def and_i_provide_the_expected_otp
    # TODO: inspect sent email once mailer code is implemented
    user = User.find_by(email: "test@example.com")
    expected_otp = Devise::OtpComparison.derive_otp(user.secret_key)

    fill_in "Enter your code", with: expected_otp
    within("main") { click_on "Sign in" }
  end

  def then_i_am_signed_in
    within(".govuk-header") { expect(page).to have_content "Sign out" }
  end

  def and_i_am_not_prompted_to_sign_in_again
    click_on "Start now"
    expect(page).to have_current_path who_path
  end
end
