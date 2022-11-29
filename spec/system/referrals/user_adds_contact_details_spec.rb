# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Contact details", type: :system do
  include CommonSteps

  scenario "User submits contact details for the referred person" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
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
    when_i_go_back
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
    visit referrals_update_contact_details_check_answers_path(@referral)
  end

  def and_i_click_on_contact_details
    click_link "Contact details"
  end

  def when_i_go_back
    click_link "Back"
  end

  def then_i_see_the_personal_email_address_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/contact-details/email"
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
      "/referrals/#{@referral.id}/contact-details/telephone"
    )
    expect(page).to have_title("Do you know their main contact number?")
    expect(page).to have_content("Do you know their main contact number?")
  end

  def then_i_see_the_home_address_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/contact-details/address"
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
    expect(page).to have_content("Enter their contact number")
  end

  def when_i_select_yes_with_an_invalid_phone_number
    when_i_select_yes
    fill_in "Main contact number", with: "1234"
  end

  def then_i_see_an_invalid_phone_number_error
    expect(page).to have_content(
      "Enter a valid mobile number, like 07700 900 982 or +44 7700 900 982"
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
    expect(page).to have_content("Enter their town or city")
    expect(page).to have_content("Enter their postcode")
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
      "/referrals/#{@referral.id}/contact-details/check-answers"
    )
    expect(page).to have_title("Have you completed this section?")
    expect(page).to have_content("Contact details")
    expect(page).to have_content("About the person you are referring")
  end

  def and_i_see_a_summary_list
    summary_rows = all(".govuk-summary-list__row")

    within(summary_rows[0]) do
      expect(find(".govuk-summary-list__key").text).to eq("Email address")
      expect(find(".govuk-summary-list__value").text).to eq("name@example.com")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href:
          referrals_edit_contact_details_email_path(
            @referral,
            return_to: current_url
          )
      )
    end

    within(summary_rows[1]) do
      expect(find(".govuk-summary-list__key").text).to eq("Phone number")
      expect(find(".govuk-summary-list__value").text).to eq("07700 900 982")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href:
          referrals_edit_contact_details_telephone_path(
            @referral,
            return_to: current_url
          )
      )
    end

    within(summary_rows[2]) do
      expect(find(".govuk-summary-list__key").text).to eq("Address")
      expect(find(".govuk-summary-list__value").text).to eq(
        "1428 Elm Street\nLondon\nNW1 4NP"
      )
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href:
          referrals_edit_contact_details_address_path(
            @referral,
            return_to: current_url
          )
      )
    end
  end

  def then_i_see_a_completed_error
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def then_i_see_the_status_section_in_the_referral_summary(status: "COMPLETED")
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[1]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Contact details"
        )
        expect(find(".app-task-list__tag").text).to eq(status)
      end
    end
  end

  def and_i_click_the_change_email_link
    within(all(".govuk-summary-list__row")[0]) { click_link "Change" }
  end

  def and_i_click_the_change_phone_link
    within(all(".govuk-summary-list__row")[1]) { click_link "Change" }
  end

  def and_i_click_the_change_address_link
    within(all(".govuk-summary-list__row")[2]) { click_link "Change" }
  end
end
