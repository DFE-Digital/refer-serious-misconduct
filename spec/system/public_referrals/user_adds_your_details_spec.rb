require "rails_helper"

RSpec.feature "Public flow: Your details", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "adding your details" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    and_i_visit_the_referral
    and_i_click_on_the_your_details_task
    then_i_see_the_your_name_page

    when_i_enter_my_name
    and_i_click_save_and_continue
    then_i_see_the_what_is_your_phone_number_page
  end

  private

  def and_i_click_on_the_your_details_task
    click_link "Your details"
  end

  def then_i_see_the_what_is_your_phone_number_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/referrer-phone/edit"
    )
    expect(page).to have_title(
      "What is your main contact number? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your main contact number?")
  end

  def then_i_see_the_your_name_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/referrer-name/edit",
      ignore_query: true
    )
    expect(page).to have_title(
      "What is your name? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your name?")
  end

  def when_i_click_on_your_details
    click_link "Your details"
  end

  def when_i_enter_my_name
    fill_in "What is your name?", with: "Test Name"
  end
end
