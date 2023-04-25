require "rails_helper"

RSpec.feature "User is sent to correct part of form", type: :system do
  include CommonSteps

  scenario "User with existing referral visits" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_i_am_signed_in
    and_i_am_a_member_of_the_public_with_an_existing_referral
    when_i_visit_the_service
    then_i_see_the_public_referral_summary

    when_i_click_on_your_details
    then_i_am_on_the_your_name_page

    when_i_enter_my_name
    and_i_click_save_and_continue
    then_i_see_the_what_is_your_phone_number_page

    when_i_enter_my_phone_number
    and_i_click_save_and_continue
    then_i_see_the_check_your_answers_page("Your details", "referrer")

    when_i_visit_the_service
    and_i_click_on_your_details
    then_i_see_the_check_your_answers_page("Your details", "referrer")

    and_i_choose_no_come_back_later
    and_i_click_save_and_continue

    then_i_see_the_public_referral_summary

    when_i_click_on_your_details
    then_i_see_the_check_your_answers_page("Your details", "referrer")

    when_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary

    when_i_click_on_your_details
    then_i_see_the_check_your_answers_page("Your details", "referrer")
  end

  private

  def then_i_see_the_do_you_have_an_account
    expect(page).to have_content("Do you have an account?")
  end
end
