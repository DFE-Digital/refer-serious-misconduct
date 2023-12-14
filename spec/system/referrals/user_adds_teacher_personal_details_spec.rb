# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Personal details", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "User adds personal details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_visit_the_referral
    then_i_see_the_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_back
    then_i_see_the_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_see_name_field_validation_errors

    when_i_fill_out_the_name_fields_and_save
    and_i_click_save_and_continue
    then_i_am_asked_their_date_of_birth

    when_i_visit_the_referral
    when_i_edit_personal_details
    then_i_see_the_check_your_answers_page("Personal details", "teacher_personal_details")

    when_i_click_on_change_their_name
    and_i_click_back
    then_i_see_the_check_your_answers_page("Personal details", "teacher_personal_details")

    when_i_click_on_change_their_name
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_am_asked_their_date_of_birth

    and_i_click_save_and_continue
    then_i_see_age_field_validation_errors

    when_i_fill_out_their_date_of_birth
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_national_insurance_number

    when_i_click_back
    then_i_am_asked_their_date_of_birth
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_national_insurance_number

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_national_insurance_validation_errors

    when_i_fill_in_the_national_insurance_number
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_trn

    when_i_click_back
    then_i_am_asked_if_i_know_their_national_insurance_number

    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_trn

    and_i_click_save_and_continue
    then_i_see_trn_field_validation_errors

    when_i_fill_out_their_trn
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_whether_they_have_qts

    when_i_click_back
    then_i_am_asked_if_i_know_their_trn
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_whether_they_have_qts

    and_i_click_save_and_continue
    then_i_see_qts_field_validation_errors

    when_i_fill_out_their_qts
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_their_personal_details

    when_i_click_change_qts
    then_i_am_asked_if_i_know_whether_they_have_qts
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_their_personal_details

    and_i_click_save_and_continue
    then_i_see_confirmation_validation_errors

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_i_see_personal_details_flagged_as_incomplete

    when_i_click_on_personal_details
    then_i_am_asked_to_confirm_their_personal_details

    when_i_visit_the_referral
    and_i_click_review_and_send
    then_i_see_the_section_completion_message("Personal details", "teacher_personal_details")

    when_i_click_on_complete_section("Personal details")
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_the_completed_section_in_the_referral_summary

    when_i_click_review_and_send
    then_i_see_the_complete_section("Personal details")
  end

  private

  def when_i_edit_personal_details
    within(all(".app-task-list__section")[1]) { click_on "Personal details" }
  end

  def and_i_am_asked_their_name
    expect(page).to have_content("Personal details")
    expect(page).to have_content("Their name")
  end

  def then_i_see_name_field_validation_errors
    expect(page).to have_content("Enter their first name")
    expect(page).to have_content("Enter their last name")
  end

  def when_i_fill_out_the_name_fields_and_save
    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Smith"
    choose "Yes", visible: false
    fill_in "Other name", with: "Jane Jones"
  end

  def then_i_am_asked_their_date_of_birth
    expect(page).to have_content("Do you know their date of birth?")
  end

  def then_i_see_age_field_validation_errors
    expect(page).to have_content("Select yes if you know their date of birth")
  end

  def when_i_fill_out_their_date_of_birth
    choose "Yes", visible: false
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end

  def then_i_am_asked_if_i_know_their_trn
    expect(page).to have_content("Do you know their teacher reference number (TRN)?")
    expect(page).to have_content("A TRN is 7 digits long, for example 4567814.")
  end

  def then_i_see_trn_field_validation_errors
    expect(page).to have_content("Select yes if you know their TRN")
  end

  def when_i_fill_out_their_trn
    choose "Yes", visible: false
    fill_in "TRN", with: "9912345"
  end

  def then_i_am_asked_if_i_know_whether_they_have_qts
    expect(page).to have_content("Do they have qualified teacher status (QTS)?")
  end

  def then_i_see_qts_field_validation_errors
    expect(page).to have_content("Select yes if they have QTS")
  end

  def when_i_fill_out_their_qts
    choose "Yes", visible: false
  end

  def then_i_am_asked_to_confirm_their_personal_details
    expect(page).to have_content("Personal details")
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Their name",
      value: "Jane Smith",
      change_link:
        edit_referral_teacher_personal_details_name_path(@referral, return_to: current_path)
    )

    expect_summary_row(
      key: "Date of birth",
      value: "17 January 1990",
      change_link:
        edit_referral_teacher_personal_details_age_path(@referral, return_to: current_path)
    )

    expect_summary_row(
      key: "TRN",
      value: "9912345",
      change_link:
        edit_referral_teacher_personal_details_trn_path(@referral, return_to: current_path),
      exact_text: true
    )

    expect_summary_row(
      key: "Do they have qualified teacher status (QTS)?",
      value: "Yes",
      change_link:
        edit_referral_teacher_personal_details_qts_path(@referral, return_to: current_path)
    )

    expect(page).to have_content("Have you completed this section?")
  end

  def then_i_see_confirmation_validation_errors
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def then_i_see_the_completed_section_in_the_referral_summary
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq("Personal details")
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end

  def then_i_am_asked_if_i_know_their_national_insurance_number
    expect(page).to have_title("Do you know their National Insurance number?")
    expect(page).to have_content("Do you know their National Insurance number?")
  end

  def then_i_see_the_national_insurance_validation_errors
    expect(page).to have_content("Enter their National Insurance number")
  end

  def when_i_click_change_qts
    click_on "Change if they have qualified teacher status (QTS)"
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_fill_in_the_national_insurance_number
    fill_in "National Insurance number", with: "QQ 12 34 56 C", visible: false
  end

  def when_i_click_on_change_their_name
    click_on "Change their name"
  end
end
