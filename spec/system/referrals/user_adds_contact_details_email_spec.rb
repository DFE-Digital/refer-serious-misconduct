# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Contact details" do
  scenario "User submits contact details for the referred person" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral_summary
    and_i_click_on_contact_details
    then_i_see_the_personal_email_address_page

    when_i_select_yes
    and_i_press_continue
    then_i_see_a_missing_email_error

    when_i_select_yes_with_an_invalid_email
    and_i_press_continue
    then_i_see_an_invalid_email_error

    when_i_select_yes_with_a_valid_email
    and_i_press_continue
    then_i_see_the_home_address_page

    when_i_go_back
    when_i_select_no
    and_i_press_continue
    then_i_see_the_home_address_page

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
    when_i_select_no
    and_i_press_continue
    then_i_get_redirected_to_the_referral_summary
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
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
