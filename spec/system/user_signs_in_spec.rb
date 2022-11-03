# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  scenario "User signs in" do
    given_the_service_is_open
    when_i_visit_the_sign_in_page
    and_i_submit_my_email
    when_i_provide_the_wrong_otp
    then_i_see_an_error
    when_i_submit_my_email
    when_i_provide_the_expected_otp
    then_i_am_signed_in
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def when_i_visit_the_sign_in_page
    visit root_path
    within(".govuk-header") do
      click_link "Sign in"
    end
  end

  def and_i_submit_my_email
    fill_in "Email", with: "test@example.com"
    click_on "Send code"
  end
  alias_method :when_i_submit_my_email, :and_i_submit_my_email

  def when_i_provide_the_wrong_otp
    fill_in "Otp", with: "wrong_value"
    within("main") do
      click_on "Sign in"
    end
  end

  def then_i_see_an_error
    expect(page).to have_content "Invalid code"
  end

  def when_i_provide_the_expected_otp
    # TODO: inspect sent email once mailer code is implemented
    user = User.find_by(email: "test@example.com")
    expected_otp = Devise::OtpComparison.derive_otp(user.secret_key)

    fill_in "Otp", with: expected_otp
    within("main") do
      click_on "Sign in"
    end
  end

  def then_i_am_signed_in
    within(".govuk-header") do
      expect(page).to have_content "Sign out"
    end
  end
end

