# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Teacher role", type: :system do
  include CommonSteps
  include SummaryListHelpers
  include TaskListHelpers

  scenario "User adds teacher role details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_visit_the_referral
    then_i_see_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary(
      status: "NOT STARTED YET"
    )

    when_i_edit_teacher_role_details

    # Their job title

    then_i_see_the_job_title_page

    when_i_click_save_and_continue
    then_i_see_job_title_field_validation_errors

    when_i_fill_in_the_job_title_field
    when_i_click_save_and_continue

    # How do you want to give details about their main duties?

    then_i_see_the_duties_page

    when_i_click_save_and_continue
    then_i_see_duties_format_field_validation_errors

    when_i_choose_upload
    and_i_click_save_and_continue
    then_i_see_duties_upload_field_validation_errors

    when_i_choose_details
    and_i_click_save_and_continue
    then_i_see_duties_details_field_validation_errors

    and_i_choose_upload
    and_i_attach_a_job_description_file
    and_i_click_save_and_continue
    then_i_see_the_same_organisation_page

    when_i_visit_the_duties_page
    and_i_see_the_uploaded_filename
    and_i_choose_upload
    and_i_attach_a_second_job_description_file
    and_i_click_save_and_continue
    then_i_see_the_same_organisation_page

    when_i_visit_the_duties_page
    and_i_see_the_second_uploaded_filename
    and_i_choose_details
    when_i_fill_in_the_duties_field
    and_i_click_save_and_continue

    # Did they work at the same organisation as you at the time of the alleged misconduct?

    then_i_see_the_same_organisation_page

    when_i_click_save_and_continue
    then_i_see_same_organisation_field_validation_errors

    when_i_choose_yes
    when_i_click_save_and_continue
    then_i_see_the_job_start_date_page

    when_i_click_save_and_continue
    then_i_see_role_start_date_known_field_validation_errors

    when_i_choose_no
    and_i_click_save_and_continue

    then_i_see_the_employed_status_page
    when_i_click_back
    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_role_start_date_field_validation_errors

    when_i_choose_yes
    when_i_fill_out_the_role_start_date_fields
    and_i_click_save_and_continue

    # Are they still employed in that job?

    then_i_see_the_employed_status_page

    when_i_click_save_and_continue
    then_i_see_employment_status_field_validation_errors

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_employment_status_page
    when_i_choose_employed
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_employment_status_page
    when_i_choose_left
    and_i_click_save_and_continue
    then_i_see_the_job_end_date_page

    when_i_click_save_and_continue
    then_i_see_role_end_date_field_validation_errors

    when_i_choose_yes
    when_i_fill_out_the_role_end_date_fields
    and_i_click_save_and_continue

    then_i_see_the_reason_leaving_role_page

    when_i_click_save_and_continue
    then_i_see_reason_leaving_role_field_validation_errors

    when_i_choose_resigned
    and_i_click_save_and_continue

    # Do you know if they are teaching somewhere else

    then_i_see_the_working_somewhere_else_page
    when_i_click_save_and_continue
    then_i_see_working_somewhere_else_field_validation_errors

    when_i_choose_no
    when_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_working_somewhere_else_page
    and_i_choose_yes
    when_i_click_save_and_continue

    # Do you know the name and address of the organisation where they’re currently working?

    then_i_see_the_work_location_known_page

    when_i_click_save_and_continue
    then_i_see_work_location_field_validation_errors

    when_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_work_location_known_page
    and_i_choose_yes
    when_i_click_save_and_continue

    # Where they currently work

    then_i_see_the_work_location_page
    when_i_click_save_and_continue
    then_i_see_work_location_address_field_validation_errors

    when_i_fill_in_the_teaching_address_details
    when_i_click_save_and_continue

    # Check and confirm your answers

    then_i_see_the_check_answers_page

    when_i_click_save_and_continue
    then_i_see_a_completed_error

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary

    # Not completed
    when_i_visit_the_check_answers_page
    when_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary(status: "INCOMPLETE")

    # Check answers back link
    when_i_visit_the_check_answers_page
    when_i_click_back
    then_i_see_the_referral_summary
  end

  private

  def when_i_visit_the_employment_status_page
    visit edit_referral_teacher_role_employment_status_path(@referral)
  end

  def when_i_visit_the_job_title_page
    visit edit_referral_teacher_role_job_title_path(@referral)
  end

  def when_i_visit_the_same_organisation_page
    visit edit_referral_teacher_role_same_organisation_path(@referral)
  end

  def when_i_visit_the_duties_page
    visit edit_referral_teacher_role_duties_path(@referral)
  end

  def when_i_visit_the_working_somewhere_else_page
    visit edit_referral_teacher_role_working_somewhere_else_path(@referral)
  end

  def when_i_visit_the_work_location_known_page
    visit edit_referral_teacher_role_work_location_known_path(@referral)
  end

  def when_i_visit_the_work_location_page
    visit edit_referral_teacher_role_work_location_path(@referral)
  end

  def when_i_visit_the_check_answers_page
    visit edit_referral_teacher_role_check_answers_path(@referral)
  end

  # Page URL/Title

  def then_i_see_the_employed_status_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_employment_status_path(@referral)
    )
    expect(page).to have_title(
      "Are they still employed in the job where the alleged misconduct took place?"
    )
    expect(page).to have_content(
      "Are they still employed in the job where the alleged misconduct took place?"
    )
  end

  def then_i_see_the_job_title_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_job_title_path(@referral)
    )
    expect(page).to have_title("Their job title")
    expect(page).to have_content("Their job title")
  end

  def then_i_see_the_same_organisation_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_same_organisation_path(@referral)
    )
    expect(page).to have_title(
      "Did they work at the same organisation as you at the time of the alleged misconduct?"
    )
    expect(page).to have_content(
      "Did they work at the same organisation as you at the time of the alleged misconduct?"
    )
  end

  def then_i_see_the_duties_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_duties_path(@referral)
    )
    expect(page).to have_title(
      "How do you want to give details about their main duties?"
    )
    expect(page).to have_content(
      "How do you want to give details about their main duties?"
    )
  end

  def then_i_see_the_job_start_date_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_start_date_path(@referral)
    )
    expect(page).to have_title("Do you know when they started their job?")
    expect(page).to have_content("Do you know when they started their job?")
  end

  def then_i_see_the_job_end_date_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_end_date_path(@referral)
    )
    expect(page).to have_title("Do you know when they left the job?")
    expect(page).to have_content("Do you know when they left the job?")
  end

  def then_i_see_the_reason_leaving_role_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_reason_leaving_role_path(@referral)
    )
    expect(page).to have_title("Reason they left the job")
    expect(page).to have_content("Reason they left the job")
  end

  def then_i_see_the_working_somewhere_else_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_working_somewhere_else_path(@referral)
    )
    expect(page).to have_title("Are they employed somewhere else?")
    expect(page).to have_content("Are they employed somewhere else?")
  end

  def then_i_see_the_work_location_known_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_work_location_known_path(@referral)
    )
    expect(page).to have_title(
      "Do you know the name and address of the organisation where they’re currently working?"
    )
    expect(page).to have_content(
      "Do you know the name and address of the organisation where they’re currently working?"
    )
  end

  def then_i_see_the_work_location_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_work_location_path(@referral)
    )
    expect(page).to have_title("Where they currently work")
    expect(page).to have_content("Where they currently work")
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path(
      edit_referral_teacher_role_check_answers_path(@referral)
    )
    expect(page).to have_title("Check and confirm your answers")
    expect(page).to have_content("Check and confirm your answers")
  end

  # Clicks

  def when_i_edit_teacher_role_details
    within(all(".app-task-list__section")[1]) { click_on "About their role" }
  end

  # Radios

  def when_i_choose_yes
    choose "Yes", visible: false
  end
  alias_method :and_i_choose_yes, :when_i_choose_yes

  def when_i_choose_no
    choose "No", visible: false
  end
  alias_method :and_i_choose_no, :when_i_choose_no

  def when_i_choose_employed
    choose "They’re still employed but they’ve been suspended", visible: false
  end

  def when_i_choose_left
    choose "No, they have left the organisation", visible: false
  end

  def when_i_choose_resigned
    choose "Resigned", visible: false
  end

  def when_i_choose_upload
    choose "Upload file", visible: false
  end
  alias_method :and_i_choose_upload, :when_i_choose_upload

  def when_i_choose_details
    choose "Describe their main duties", visible: false
  end
  alias_method :and_i_choose_details, :when_i_choose_details

  # Text inputs

  def when_i_fill_out_the_role_start_date_fields
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end
  alias_method :when_i_fill_out_the_role_end_date_fields,
               :when_i_fill_out_the_role_start_date_fields

  def when_i_fill_in_the_job_title_field
    fill_in "Their job title", with: "Teacher"
  end

  def when_i_fill_in_the_duties_field
    fill_in "Description of their main duties", with: "Main duties"
  end

  def when_i_fill_in_the_teaching_address_details
    fill_in "Organisation name", with: "High School"
    fill_in "Address line 1", with: "1428 Elm Street"
    fill_in "Town or city", with: "London"
    fill_in "Postcode", with: "NW1 4NP"
  end

  # File uploads

  def and_i_attach_a_job_description_file
    attach_file(
      "Upload file",
      File.absolute_path(Rails.root.join("spec/fixtures/files/upload1.pdf"))
    )
  end

  def and_i_attach_a_second_job_description_file
    attach_file(
      "Upload file",
      File.absolute_path(Rails.root.join("spec/fixtures/files/upload2.pdf"))
    )
  end

  # Validation errors

  def then_i_see_employment_status_field_validation_errors
    expect(page).to have_content(
      "Select whether they’re still employed where the alleged misconduct took place"
    )
  end

  def then_i_see_reason_leaving_role_field_validation_errors
    expect(page).to have_content("Select the reason they left the job")
  end

  def then_i_see_role_start_date_known_field_validation_errors
    expect(page).to have_content(
      "Select yes if you know when they started their job"
    )
  end

  def then_i_see_role_start_date_field_validation_errors
    expect(page).to have_content("Enter the job start date")
  end

  def then_i_see_role_end_date_field_validation_errors
    expect(page).to have_content(
      "Select yes if you know when they left the job"
    )
  end

  def then_i_see_job_title_field_validation_errors
    expect(page).to have_content("Enter their job title")
  end

  def then_i_see_same_organisation_field_validation_errors
    expect(page).to have_content(
      "Select yes if they worked at the same organisation as you at the time of the alleged misconduct"
    )
  end

  def then_i_see_duties_format_field_validation_errors
    expect(page).to have_content(
      "Select how you want to give details about their main duties"
    )
  end

  def then_i_see_duties_upload_field_validation_errors
    expect(page).to have_content(
      "Select a file containing a description of their main duties"
    )
  end

  def then_i_see_duties_details_field_validation_errors
    expect(page).to have_content("Enter a description of their main duties")
  end

  def then_i_see_working_somewhere_else_field_validation_errors
    expect(page).to have_content(
      "Select yes if they’re employed somewhere else"
    )
  end

  def then_i_see_work_location_field_validation_errors
    expect(page).to have_content(
      "Select yes if you know the name and address of the organisation where they’re currently working"
    )
  end

  def then_i_see_work_location_address_field_validation_errors
    expect(page).to have_content("Enter the organisation name")
    expect(page).to have_content("Enter the first line of the address")
    expect(page).to have_content("Enter the town or city")
    expect(page).to have_content("Enter the postcode")
  end

  def then_i_see_a_completed_error
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  # Page content

  def and_i_see_the_uploaded_filename
    expect(page).to have_content("Uploaded file: upload1.pdf")
  end

  def and_i_see_the_second_uploaded_filename
    expect(page).to have_content("Uploaded file: upload2.pdf")
  end

  def then_i_see_the_status_section_in_the_referral_summary(status: "COMPLETED")
    expect_task_row(
      section: "About the person you’re referring",
      item_position: 3,
      name: "About their role",
      tag: status
    )
  end
end
