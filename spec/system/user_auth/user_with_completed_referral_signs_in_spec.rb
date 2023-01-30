# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  include CommonSteps

  scenario "User with completed referral signs in" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active

    when_i_visit_the_service
    and_i_have_a_completed_referral
    and_click_start_now
    and_choose_continue_referral
    and_i_submit_my_email

    when_i_provide_the_expected_otp
    then_i_am_signed_in
    then_i_see_the_confirmation_page
  end

  private

  def and_i_have_a_completed_referral
    @user = create(:user)
    @referral = create(:referral, user: @user, submitted_at: 1.day.ago)
  end

  def and_click_start_now
    click_on "Start now"
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

  def then_i_am_signed_in
    within(".govuk-header") { expect(page).to have_content "Sign out" }
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/confirmation")
    expect(page).to have_title("Referral sent")
    expect(page).to have_content("Referral sent")
  end
end
