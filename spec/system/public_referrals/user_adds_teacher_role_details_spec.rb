# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Teacher role", type: :system do
  include CommonSteps
  include SummaryListHelpers
  include TaskListHelpers

  scenario "A member of the public adds teacher role details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    and_i_visit_the_public_referral
    then_i_see_the_public_referral_summary
    and_i_see_the_status_section_in_the_referral_summary(status: "INCOMPLETE")

    when_i_edit_teacher_role_details
    then_i_see_the_job_title_page

    when_i_click_save_and_continue
    then_i_see_job_title_field_validation_errors

    when_i_fill_in_the_job_title_field
    and_i_click_save_and_continue
    then_i_see_the_duties_page

    when_i_visit_the_referral
    when_i_edit_teacher_role_details
    then_i_see_the_check_your_answers_page("About their role", "teacher-role")

    when_i_click_on_complete_your_details
    when_i_click_save_and_continue
    then_i_see_duties_format_field_validation_errors

    when_i_choose_upload
    and_i_click_save_and_continue
    then_i_see_duties_upload_field_validation_errors

    when_i_choose_details
    and_i_click_save_and_continue
    then_i_see_duties_details_field_validation_errors

    when_i_choose_upload
    and_i_attach_a_job_description_file
    and_i_click_save_and_continue
    then_i_see_the_organisation_address_known_page

    when_i_visit_the_duties_page
    and_i_see_the_uploaded_filename
    and_i_choose_upload
    and_i_attach_a_second_job_description_file
    and_i_click_save_and_continue
    then_i_see_the_organisation_address_known_page

    when_i_visit_the_duties_page
    and_i_see_the_second_uploaded_filename
    and_i_choose_details
    and_i_fill_in_the_duties_field
    and_i_click_save_and_continue

    # Do you know the name and address of the organisation where the alleged misconduct took place?

    then_i_see_the_organisation_address_known_page

    when_i_click_save_and_continue
    then_i_see_organisation_address_known_field_validation_errors

    when_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_organisation_address_known_page
    and_i_choose_yes
    and_i_click_save_and_continue

    # Name and address of the organisation where the alleged misconduct took place

    then_i_see_the_organisation_address_page

    when_i_click_save_and_continue
    then_i_see_organisation_address_fields_validation_errors

    when_i_fill_in_the_organisation_address_details
    and_i_click_save_and_continue

    # Check and confirm your answers

    then_i_see_the_check_answers_page

    when_i_click_save_and_continue
    then_i_see_a_completed_error

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_i_see_the_status_section_in_the_referral_summary

    # Not completed

    when_i_visit_the_check_answers_page
    and_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_i_see_the_status_section_in_the_referral_summary(status: "INCOMPLETE")

    when_i_visit_the_referral
    and_i_click_review_and_send
    then_i_see_the_section_completion_message("About their role", "teacher_role")

    when_i_click_on_complete_section("About their role")
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_the_completed_section_in_the_referral_summary

    when_i_click_review_and_send
    then_i_see_the_complete_section("About their role")
  end

  private

  def when_i_visit_the_job_title_page
    visit edit_public_referral_teacher_role_job_title_path(@referral)
  end

  def when_i_visit_the_duties_page
    visit edit_public_referral_teacher_role_duties_path(@referral)
  end

  def when_i_visit_the_organisation_address_known_page
    visit edit_public_referral_teacher_role_organisation_address_known_path(@referral)
  end

  def when_i_visit_the_check_answers_page
    visit edit_public_referral_teacher_role_check_answers_path(@referral)
  end

  # Page URL/Title

  def then_i_see_the_job_title_page
    expect(page).to have_current_path(edit_public_referral_teacher_role_job_title_path(@referral))
    expect(page).to have_title("Their job title")
    expect(page).to have_content("Their job title")
  end

  def then_i_see_the_duties_page
    expect(page).to have_current_path(edit_public_referral_teacher_role_duties_path(@referral))
    expect(page).to have_title("How do you want to give details about their main duties?")
    expect(page).to have_content("How do you want to give details about their main duties?")
  end

  def then_i_see_the_organisation_address_known_page
    expect(page).to have_current_path(
      edit_public_referral_teacher_role_organisation_address_known_path(@referral)
    )
    expect(page).to have_title("Do you know the name and address of the organisation?")
    expect(page).to have_content(
      "Do you know the name and address of the organisation where the alleged misconduct took place?"
    )
  end

  def then_i_see_the_organisation_address_page
    expect(page).to have_current_path(
      edit_public_referral_teacher_role_organisation_address_path(@referral)
    )
    expect(page).to have_title(
      "Name and address of the organisation where the alleged misconduct took place"
    )
    expect(page).to have_content(
      "Name and address of the organisation where the alleged misconduct took place"
    )
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path(
      edit_public_referral_teacher_role_check_answers_path(@referral)
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

  def when_i_choose_upload
    choose "Upload file", visible: false
  end
  alias_method :and_i_choose_upload, :when_i_choose_upload

  def when_i_choose_details
    choose "Describe their main duties", visible: false
  end
  alias_method :and_i_choose_details, :when_i_choose_details

  # Text inputs

  def when_i_fill_in_the_job_title_field
    fill_in "Their job title", with: "Teacher"
  end

  def and_i_fill_in_the_duties_field
    fill_in "Description of their main duties", with: "Morganisationes"
  end

  def when_i_fill_in_the_organisation_address_details
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
      "Upload new file",
      File.absolute_path(Rails.root.join("spec/fixtures/files/upload2.pdf"))
    )
  end

  # Validation errors

  def then_i_see_job_title_field_validation_errors
    expect(page).to have_content("Enter their job title")
  end

  def then_i_see_duties_format_field_validation_errors
    expect(page).to have_content("Select how you want to give details about their main duties")
  end

  def then_i_see_duties_upload_field_validation_errors
    expect(page).to have_content("Select a file containing a description of their main duties")
  end

  def then_i_see_duties_details_field_validation_errors
    expect(page).to have_content("Enter a description of their main duties")
  end

  def then_i_see_organisation_address_known_field_validation_errors
    expect(page).to have_content("Select yes if you know the name and address of the organisation")
  end

  def then_i_see_organisation_address_fields_validation_errors
    expect(page).to have_content("Enter the organisation name")
    expect(page).to have_content("Enter the first line of the organisation's address")
    expect(page).to have_content("Enter a town or city for the organisation")
    expect(page).to have_content("Enter a postcode for the organisation")
  end

  def then_i_see_a_completed_error
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  # Page content

  def and_i_see_the_uploaded_filename
    expect(page).to have_content("upload1.pdf (4.98KB)")
  end

  def and_i_see_the_second_uploaded_filename
    expect(page).to have_content("upload2.pdf (5.11KB)")
  end

  def and_i_see_the_status_section_in_the_referral_summary(status: "COMPLETED")
    expect_task_row(
      section: "About the teacher",
      item_position: 2,
      name: "About their role",
      tag: status
    )
  end

  def when_i_click_on_change_their_duties_format
    click_on "Change how you want to give details about their main duties"
  end

  def then_i_see_the_completed_section_in_the_referral_summary
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[1]) do
        expect(find(".app-task-list__task-name a").text).to eq("About their role")
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end
end
