# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  include CommonSteps

  scenario "User with completed referral signs in" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active

    given_i_have_a_completed_referral
    when_i_visit_the_service
    and_choose_continue_referral
    and_i_submit_my_email

    when_i_provide_the_expected_otp
    then_i_am_signed_in
    then_i_see_the_referrals_page

    when_i_click_on_the_start_a_referral_link
    and_i_complete_the_screener
    and_i_sign_out
    and_i_sign_back_in

    then_i_am_signed_in
    and_i_see_the_referrals_page
    and_i_can_continue_the_referral_in_progress
  end

  private

  def given_i_have_a_completed_referral
    @user = create(:user)

    @referral = create(:referral, :personal_details_public, user: @user)

    travel_to Time.zone.local(2022, 11, 29, 12, 0, 0)
    @referral.update(submitted_at: Time.current)
    travel_back
  end

  def and_choose_continue_referral
    choose "Yes, sign in and continue making a referral", visible: false
    click_on "Continue"
  end

  def and_i_submit_my_email
    fill_in "user-email-field", with: @user.email
    click_on "Continue"
  end

  def when_i_provide_the_expected_otp
    perform_enqueued_jobs

    user = User.find(@user.id)
    expected_otp = Devise::Otp.derive_otp(user.secret_key)

    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include expected_otp

    fill_in "Confirmation code", with: expected_otp
    within("main") { click_on "Continue" }
  end
  alias_method :and_i_provide_the_expected_otp, :when_i_provide_the_expected_otp

  def then_i_am_signed_in
    within(".govuk-header") { expect(page).to have_content "Sign out" }
  end

  def then_i_see_the_referrals_page
    expect(page).to have_current_path("/users/referrals")
    expect(page).to have_title("Your referrals")
    expect(page).to have_content("John Smith")
    expect(page).to have_content("29 November 2022 at 12:00 pm")
  end
  alias_method :and_i_see_the_referrals_page, :then_i_see_the_referrals_page

  def when_i_click_on_the_start_a_referral_link
    click_on "Start new referral"
  end

  def and_i_complete_the_screener
    choose "I’m referring as an employer", visible: false
    click_on "Continue"

    4.times do
      choose "I’m not sure", visible: false
      click_on "Continue"
    end

    click_on "Continue"
  end

  def and_i_sign_out
    within(".govuk-header") { click_on "Sign out" }
  end

  def and_i_sign_back_in
    within(".govuk-header") { click_on "Sign in" }
    and_i_submit_my_email
    and_i_provide_the_expected_otp
  end

  def and_i_can_continue_the_referral_in_progress
    click_on "Complete referral"
    expect(page).to have_current_path(
      edit_referral_path(@user.referral_in_progress)
    )
  end
end
