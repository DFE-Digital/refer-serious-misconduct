require "rails_helper"

RSpec.feature "Public Referral: About You", type: :system do
  include CommonSteps

  scenario "User provides their details" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    when_i_visit_the_public_referral
    and_i_click_on_your_details
    then_i_am_on_the_personal_details_page

    when_i_click_continue
    then_i_am_on_the_your_name_page

    when_i_click_save_and_continue
    then_i_see_the_name_error_message

    when_i_enter_my_name
    and_i_click_save_and_continue
    then_i_see_the_what_is_your_phone_number_page

    when_i_click_save_and_continue
    then_i_see_the_phone_error_message

    when_i_enter_my_phone_number
    when_i_click_save_and_continue
    then_i_see_the_referrer_check_your_answers_page
    and_i_see_my_answers_on_the_referrer_check_your_answers_page

    when_i_click_on_change_name
    then_i_am_on_the_your_name_page
    and_i_see_my_name_in_the_form_field

    when_i_click_save_and_continue
    and_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_i_see_your_details_flagged_as_incomplete

    when_i_click_on_your_details
    and_i_click_continue
    then_i_see_the_name_prefilled

    when_i_click_save_and_continue
    then_i_see_the_phone_number_prefilled

    when_i_click_save_and_continue
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_your_details_flagged_as_complete
  end

  private

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: false
  end

  def and_i_see_my_name_in_the_form_field
    expect(page).to have_field("First name", with: "John")
    expect(page).to have_field("Last name", with: "Doe")
  end

  def and_i_see_my_answers_on_the_referrer_check_your_answers_page
    expect(page).to have_content("Your name\tJohn Doe")
    expect(page).to have_content("Your phone number\t01234567890")
  end

  def and_i_see_your_details_flagged_as_incomplete
    within(".app-task-list__item", text: "Your details") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to have_content("INCOMPLETE")
    end
  end

  def then_i_am_on_the_personal_details_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/personal-details",
      ignore_query: true
    )
    expect(page).to have_title("How your personal details will be used")
    expect(page).to have_content("Your details")
  end

  def then_i_am_on_the_your_name_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/referrer-name/edit",
      ignore_query: true
    )
    expect(page).to have_title(
      "Your name - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your name")
  end

  def then_i_see_the_phone_number_prefilled
    expect(page).to have_field("Your phone number", with: "01234567890")
  end

  def then_i_see_the_name_error_message
    expect(page).to have_content("Enter your first name")
    expect(page).to have_content("Enter your last name")
  end

  def then_i_see_the_name_prefilled
    expect(page).to have_field("First name", with: "John")
    expect(page).to have_field("Last name", with: "Doe")
  end

  def then_i_see_the_referrer_check_your_answers_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/referrer"
    )
    expect(page).to have_title(
      "Your details - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your details")
  end

  def then_i_see_the_phone_error_message
    expect(page).to have_content("Enter your phone number")
  end

  def then_i_see_the_what_is_your_phone_number_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/referrer-phone/edit"
    )
    expect(page).to have_title(
      "Your phone number - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your phone number")
  end

  def then_i_see_your_details_flagged_as_complete
    within(".app-task-list__item", text: "Your details") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to match(/^COMPLETE/)
    end
  end

  def when_i_click_on_change_name
    click_on "Change your name"
  end

  def when_i_click_on_your_details
    click_link "Your details"
  end
  alias_method :and_i_click_on_your_details, :when_i_click_on_your_details

  def when_i_enter_my_name
    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
  end

  def when_i_enter_my_phone_number
    fill_in "Your phone number", with: "01234567890"
  end
end
