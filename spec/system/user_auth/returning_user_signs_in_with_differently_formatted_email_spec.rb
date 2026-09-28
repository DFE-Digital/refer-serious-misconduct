# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts" do
  include CommonSteps

  scenario "Returning user signs in with a differently formatted email" do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_the_referral_form_feature_is_active
    and_i_have_an_account

    when_i_visit_the_service
    and_choose_continue_referral
    and_i_submit_my_email_in_mixed_case_with_surrounding_spaces

    then_i_am_asked_for_the_code_sent_to_my_existing_account
    and_no_new_account_is_created
  end

  private

  def and_i_have_an_account
    @user = create(:user, email: "returning@example.com")
  end

  def and_choose_continue_referral
    find("label", text: "Yes, sign in and continue making a referral").click
    click_on "Continue"
  end

  def and_i_submit_my_email_in_mixed_case_with_surrounding_spaces
    fill_in "user-email-field", with: " Returning@Example.COM "
    click_on "Continue"
  end

  def then_i_am_asked_for_the_code_sent_to_my_existing_account
    expect(page).to have_content "A confirmation code has been sent to returning@example.com"
    expect(page).to have_current_path(new_user_otp_path(uuid: @user.uuid, new_referral: false))
  end

  def and_no_new_account_is_created
    expect(User.count).to eq 1
  end
end
