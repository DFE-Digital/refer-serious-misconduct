# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  scenario "User signs in" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    when_i_visit_the_root_page
    and_click_start_now
    and_i_submit_my_email
    when_i_provide_the_wrong_otp
    then_i_see_an_error
    when_i_submit_my_email
    and_i_provide_the_expected_otp
    then_i_am_signed_in
    and_i_am_not_prompted_to_sign_in_again

    when_i_have_a_referral_in_progress
    and_i_sign_out
    when_i_sign_back_in
    then_i_see_my_referral

    when_i_am_signed_out
    and_i_visit_a_page
    and_i_submit_my_email
    and_i_provide_the_expected_otp
    then_i_see_my_current_page_before_logging_in
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
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

  def when_i_have_a_referral_in_progress
    @referral = create(:referral, user: User.last)
  end

  def and_i_sign_out
    within(".govuk-header") { click_on "Sign out" }
  end
  alias_method :when_i_am_signed_out, :and_i_sign_out

  def when_i_sign_back_in
    within(".govuk-header") { click_on "Sign in" }
    and_i_submit_my_email
    and_i_provide_the_expected_otp
  end

  def then_i_see_my_referral
    expect(page).to have_current_path(referral_path(@referral))
  end

  def and_i_visit_a_page
    visit referrals_edit_contact_details_email_path(@referral)
  end

  def then_i_see_my_current_page_before_logging_in
    expect(page).to have_current_path(
      referrals_edit_contact_details_email_path(@referral)
    )
  end
end
