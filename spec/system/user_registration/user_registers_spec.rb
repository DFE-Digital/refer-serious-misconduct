# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User registration" do
  include CommonSteps

  scenario "User registers while requesting another confirmation code and exceeding max OTP guesses" do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_the_referral_form_feature_is_active

    when_i_visit_the_service
    and_i_start_new_referral
    and_i_complete_the_eligibility_screener
    then_i_should_see_sign_up_page

    when_i_submit_an_invalid_email_address
    then_i_should_see_the_sign_up_page_with_an_error

    when_i_submit_my_email
    then_i_should_see_the_otp_page
    and_event_tracking_is_working

    when_i_request_another_confirmation_code
    then_i_should_see_sign_up_page

    when_i_submit_my_email
    then_i_should_see_the_otp_page

    when_i_max_out_my_otp_guesses
    then_i_see_an_error_screen

    when_i_press_request_another_confirmation_code
    then_i_should_see_sign_up_page

    when_i_submit_my_email
    then_i_should_see_the_otp_page

    when_i_provide_the_expected_otp
    then_i_should_see_the_start_new_referral_page
    and_i_should_receive_an_email_with_my_referral_page_link
  end

  private

  def and_i_start_new_referral
    find("label", text: "No").click
    click_on "Continue"
  end

  def and_i_complete_the_eligibility_screener
    find("label", text: "I’m referring as an employer").click
    click_on "Continue"

    3.times do
      find("label", text: "Yes").click
      click_on "Continue"
    end

    click_on "I understand and want to continue"
  end

  def then_i_should_see_sign_up_page
    expect(page).to have_content "Your email address"
    expect(page).to have_current_path(new_user_session_path(new_referral: true))
  end

  def when_i_submit_an_invalid_email_address
    fill_in "Your email address", with: "test@email"
    click_on "Continue"
  end

  def then_i_should_see_the_sign_up_page_with_an_error
    expect(page).to have_content "Your email address"
    expect(
      page
    ).to have_content "Enter an email address in the correct format, like name@example.com"
  end

  def when_i_submit_my_email
    fill_in "Your email address", with: "test@example.com"
    click_on "Continue"
  end

  def then_i_should_see_the_otp_page
    expect(page).to have_content "Check your email"
    expect(page).to have_link(
      "request another confirmation code",
      href: new_user_session_path(new_referral: true)
    )
  end

  def when_i_request_another_confirmation_code
    click_on "request another confirmation code"
  end

  def when_i_max_out_my_otp_guesses
    Users::OtpForm::MAX_GUESSES.times do
      fill_in "Confirmation code", with: "123456"
      within("main") { click_on "Continue" }
    end
  end

  def then_i_see_an_error_screen
    expect(page).to have_content "You need to request another confirmation code"
    expect(page).to have_current_path(
      retry_user_sign_in_path(error: :exhausted, new_referral: true)
    )
  end

  def when_i_provide_the_expected_otp
    perform_enqueued_jobs

    user = User.find_by(email: "test@example.com")
    expected_otp = Devise::Otp.derive_otp(user.secret_key)

    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include expected_otp

    fill_in "Confirmation code", with: expected_otp
    within("main") { click_on "Continue" }
  end

  def then_i_should_see_the_start_new_referral_page
    expect(page).to have_content "Your referral"
  end

  def when_i_press_request_another_confirmation_code
    click_link "Request another confirmation code"
  end

  def when_i_provide_a_short_otp
    fill_in "Confirmation code", with: "123"
    within("main") { click_on "Continue" }
  end

  def and_i_should_receive_an_email_with_my_referral_page_link
    perform_enqueued_jobs

    user = User.find_by(email: "test@example.com")
    referral = user.latest_referral
    email = ActionMailer::Base.deliveries.last

    expect(email.body).to include(edit_referral_url(referral))
  end
end
