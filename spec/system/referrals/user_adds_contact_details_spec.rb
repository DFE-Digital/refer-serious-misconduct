# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Contact details", type: :system do
  include CommonSteps
  include SummaryListHelpers
  include TaskListHelpers

  scenario "User submits contact details for the referred person" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral
    then_i_see_the_status_section_in_the_referral_summary(
      status: "NOT STARTED YET"
    )
    and_i_click_on_contact_details

    # Do you know the personal email address
    then_i_see_the_personal_email_address_page

    # Email address invalid
    when_i_select_yes
    and_i_click_save_and_continue
    then_i_see_a_missing_email_error

    when_i_select_yes_with_an_invalid_email
    and_i_click_save_and_continue
    then_i_see_an_invalid_email_error

    # Email address unknown
    when_i_select_no
    and_i_click_save_and_continue

    # Email address known
    when_i_go_back
    when_i_select_yes_with_a_valid_email
    and_i_click_save_and_continue
    then_i_see_the_contact_number_page

    # Do you know their main contact number
    then_i_see_the_contact_number_page

    # Phone number errors
    when_i_select_yes
    and_i_click_save_and_continue
    then_i_see_a_missing_phone_number_error

    when_i_select_yes_with_an_invalid_phone_number
    and_i_click_save_and_continue
    then_i_see_an_invalid_phone_number_error

    # Phone number known
    when_i_select_no
    and_i_click_save_and_continue
    then_i_see_the_home_address_page

    # Phone number unknown
    when_i_go_back
    when_i_select_yes_with_a_valid_phone_number
    and_i_click_save_and_continue

    # Do you know their home address?
    then_i_see_the_home_address_page

    # Address errors
    when_i_select_yes
    and_i_click_save_and_continue
    then_i_see_a_missing_address_fields_error

    when_i_fill_in_an_incorrect_postcode
    and_i_click_save_and_continue
    then_i_see_a_invalid_postcode_error

    # Address unknown
    when_i_select_no
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    # Address known
    when_i_click_change_address
    when_i_select_yes
    when_i_fill_in_the_address_details
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page
    and_i_see_a_summary_list

    # Have you completed this section?
    and_i_click_save_and_continue
    then_i_see_a_completed_error

    when_i_select_yes
    and_i_click_save_and_continue
    then_i_get_redirected_to_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary

    # Not completed
    when_i_visit_the_check_answers_page
    when_i_select_no
    and_i_click_save_and_continue
    then_i_get_redirected_to_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary(status: "INCOMPLETE")

    # Editing single answers
    when_i_visit_the_check_answers_page
    and_i_click_the_change_email_link
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_check_answers_page
    and_i_click_the_change_phone_link
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_check_answers_page
    and_i_click_the_change_address_link
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page
  end

  private

  def when_i_visit_the_check_answers_page
    visit edit_referral_contact_details_check_answers_path(@referral)
  end

  def and_i_click_on_contact_details
    click_link "Contact details"
  end

  def when_i_go_back
    click_link "Back"
  end

  def then_i_see_the_personal_email_address_page
    expect(page).to have_current_path(
      edit_referral_contact_details_email_path(@referral)
    )
    expect(page).to have_title(
      "Do you know the personal email address of the person you are referring?"
    )
    expect(page).to have_content(
      "Do you know the personal email address of the person you are referring?"
    )
  end

  def then_i_see_the_contact_number_page
    expect(page).to have_current_path(
      edit_referral_contact_details_telephone_path(@referral)
    )
    expect(page).to have_title("Do you know their main contact number?")
    expect(page).to have_content("Do you know their main contact number?")
  end

  def then_i_see_the_home_address_page
    expect(page).to have_current_path(
      edit_referral_contact_details_address_path(@referral)
    )
    expect(page).to have_title("Do you know their home address?")
    expect(page).to have_content("Do you know their home address?")
  end

  def when_i_select_yes
    choose "Yes", visible: false
  end

  def then_i_see_a_missing_email_error
    expect(page).to have_content("Enter their email address")
  end

  def when_i_select_yes_with_an_invalid_email
    when_i_select_yes
    fill_in "Email address", with: "name"
  end

  def then_i_see_an_invalid_email_error
    expect(page).to have_content(
      "Enter an email address in the correct format, like name@example.com"
    )
  end

  def when_i_select_yes_with_a_valid_email
    when_i_select_yes
    fill_in "Email address", with: "name@example.com"
  end

  def then_i_see_a_missing_phone_number_error
    expect(page).to have_content("Enter their phone number")
  end

  def when_i_select_yes_with_an_invalid_phone_number
    when_i_select_yes
    fill_in "Main contact number", with: "1234"
  end

  def then_i_see_an_invalid_phone_number_error
    expect(page).to have_content(
      "Enter a phone number in the correct format, like 07700 900 982"
    )
  end

  def when_i_select_yes_with_a_valid_phone_number
    when_i_select_yes
    fill_in "Main contact number", with: "07700 900 982"
  end

  def then_i_get_redirected_to_the_referral_summary
    expect(page).to have_current_path("/referrals/#{@referral.id}/edit")
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def when_i_select_no
    choose "No", visible: false
  end

  def then_i_see_a_missing_address_fields_error
    expect(page).to have_content("Enter the first line of their address")
    expect(page).to have_content("Enter the town or city")
    expect(page).to have_content("Enter the postcode")
  end

  def when_i_fill_in_an_incorrect_postcode
    fill_in "Postcode", with: "postcode"
  end

  def then_i_see_a_invalid_postcode_error
    expect(page).to have_content("Enter a real postcode")
  end

  def when_i_fill_in_the_address_details
    fill_in "Address line 1", with: "1428 Elm Street"
    fill_in "Town or city", with: "London"
    fill_in "Postcode", with: "NW1 4NP"
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path(
      edit_referral_contact_details_check_answers_path(@referral)
    )
    expect(page).to have_title("Have you completed this section?")
    expect(page).to have_content("Contact details")
  end

  def and_i_see_a_summary_list
    expect_summary_row(
      key: "Email address",
      value: "name@example.com",
      change_link:
        edit_referral_contact_details_email_path(
          @referral,
          return_to: current_path
        )
    )

    expect_summary_row(
      key: "Phone number",
      value: "07700 900 982",
      change_link:
        edit_referral_contact_details_telephone_path(
          @referral,
          return_to: current_path
        )
    )

    expect_summary_row(
      key: "Address",
      value: "1428 Elm Street\nLondon\nNW1 4NP",
      change_link:
        edit_referral_contact_details_address_path(
          @referral,
          return_to: current_path
        )
    )
  end

  def then_i_see_a_completed_error
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def then_i_see_the_status_section_in_the_referral_summary(status: "COMPLETED")
    expect_task_row(
      section: "About the person you’re referring",
      item_position: 2,
      name: "Contact details",
      tag: status
    )
  end

  def and_i_click_the_change_email_link
    within(page.find(".govuk-summary-list__row", text: "Email address")) do
      click_link "Change"
    end
  end

  def and_i_click_the_change_phone_link
    within(page.find(".govuk-summary-list__row", text: "Phone number")) do
      click_link "Change"
    end
  end

  def and_i_click_the_change_address_link
    within(page.find(".govuk-summary-list__row", text: "Address")) do
      click_link "Change"
    end
  end

  def when_i_click_change_address
    click_link "Change address"
  end
end
