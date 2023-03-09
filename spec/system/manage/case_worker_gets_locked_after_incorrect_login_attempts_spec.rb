# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Manage referrals" do
  include CommonSteps

  scenario "Case worker gets locked after incorrect login attempts",
           type: :system do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_referral_forms_exist
    and_i_am_a_case_worker

    when_i_visit_the_manage_interface
    and_i_try_to_login_as_a_case_worker_with_incorrect_credentials
    then_i_see_an_error_message_for_invalid_credentials

    when_i_try_three_more_times
    then_i_see_an_error_message_for_last_attempt

    when_i_try_to_login_as_a_case_worker_with_incorrect_credentials
    then_i_see_that_my_account_is_locked_for_15_minutes

    when_i_try_to_login_as_a_case_worker_with_correct_credentials
    then_i_see_that_my_account_is_locked_for_15_minutes

    when_15_minutes_pass
    and_i_try_to_login_as_a_case_worker_with_correct_credentials
    then_i_am_logged_in
  end

  def and_i_am_a_case_worker
    create(:staff, :confirmed, :can_manage_referrals)
  end

  def when_i_visit_the_manage_interface
    visit manage_sign_in_path
  end

  def when_i_try_to_login_as_a_case_worker_with_incorrect_credentials
    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "test"

    click_on "Log in"
  end
  alias_method :and_i_try_to_login_as_a_case_worker_with_incorrect_credentials,
               :when_i_try_to_login_as_a_case_worker_with_incorrect_credentials

  def then_i_see_an_error_message_for_invalid_credentials
    expect(
      page
    ).to have_content "You entered an incorrect email address or password."
  end

  def when_i_try_three_more_times
    3.times { when_i_try_to_login_as_a_case_worker_with_incorrect_credentials }
  end

  def then_i_see_an_error_message_for_invalid_credentials
    expect(
      page
    ).to have_content "You entered an incorrect email address or password."
  end

  def then_i_see_an_error_message_for_last_attempt
    expect(
      page
    ).to have_content "You entered an incorrect email address or password - you have " \
                   "1 more attempt before your account is locked for 15 minutes."
  end

  def then_i_see_that_my_account_is_locked_for_15_minutes
    expect(page).to have_content "You cannot sign in for 15 minutes because " \
                   "you entered an incorrect email address or password 5 times."
  end

  def when_15_minutes_pass
    travel_to Time.zone.now + 16.minutes
  end

  def when_i_try_to_login_as_a_case_worker_with_correct_credentials
    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end
  alias_method :and_i_try_to_login_as_a_case_worker_with_correct_credentials,
               :when_i_try_to_login_as_a_case_worker_with_correct_credentials

  def then_i_am_logged_in
    expect(page).to have_content "Referrals (30)"
  end
end
