# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Contact details", type: :system do
  scenario "User submits contact details for the referred person" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral_summary
    and_i_click_on_contact_details

    # Do you know the personal email address
    then_i_see_the_personal_email_address_page

    # Email address known
    when_i_select_yes
    and_i_press_continue
    then_i_see_a_missing_email_error

    when_i_select_yes_with_an_invalid_email
    and_i_press_continue
    then_i_see_an_invalid_email_error

    when_i_select_yes_with_a_valid_email
    and_i_press_continue
    then_i_see_the_contact_number_page

    # Email address unknown
    when_i_go_back
    when_i_select_no
    and_i_press_continue

    # Do you know their main contact number
    then_i_see_the_contact_number_page

    # Phone number known
    when_i_select_yes
    and_i_press_continue
    then_i_see_a_missing_phone_number_error

    when_i_select_yes_with_an_invalid_phone_number
    and_i_press_continue
    then_i_see_an_invalid_phone_number_error

    when_i_select_yes_with_a_valid_phone_number
    and_i_press_continue
    then_i_see_the_home_address_page

    # Phone number unknown
    when_i_go_back
    when_i_select_no
    and_i_press_continue

    # Do you know their home address?
    then_i_see_the_home_address_page

    # Address known
    when_i_select_yes
    and_i_press_continue
    then_i_see_a_missing_address_fields_error

    when_i_fill_in_an_incorrect_postcode
    and_i_press_continue
    then_i_see_a_invalid_postcode_error

    when_i_fill_in_the_address_details
    and_i_press_continue
    then_i_get_redirected_to_the_referral_summary

    and_i_click_on_contact_details
    and_i_press_continue # skip the email page
    and_i_press_continue # skip the telephone page

    # Address unknown
    when_i_select_no
    and_i_press_continue
    then_i_get_redirected_to_the_referral_summary
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_i_have_an_existing_referral
    @referral = Referral.create!
  end

  def when_i_visit_the_referral_summary
    visit edit_referral_path(@referral)
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

  def and_i_press_continue
    click_on "Save and continue"
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
    fill_in "Contact number", with: "1234"
  end

  def then_i_see_an_invalid_phone_number_error
    expect(page).to have_content(
      "Enter a valid mobile number, like 07700 900 982 or +44 7700 900 982"
    )
  end

  def when_i_select_yes_with_a_valid_phone_number
    when_i_select_yes
    fill_in "Contact number", with: "07700 900 982"
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
end
