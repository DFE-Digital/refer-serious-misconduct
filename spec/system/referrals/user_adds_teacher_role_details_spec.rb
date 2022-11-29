# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Teacher role", type: :system do
  scenario "User adds teacher role details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    and_i_visit_a_referral
    then_i_see_the_referral_summary
    then_i_see_the_status_section_in_the_referral_summary(
      status: "NOT STARTED YET"
    )

    when_i_edit_teacher_role_details

    # Do you know when they started their job?

    then_i_see_the_job_start_date_page
    and_i_click_back
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    then_i_see_the_job_start_date_page
    and_i_click_save_and_continue
    then_i_see_role_start_date_known_field_validation_errors

    when_i_choose_no
    and_i_click_save_and_continue

    # Are they still employed in that job?

    then_i_see_the_employed_status_page
    when_i_click_back
    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_role_start_date_field_validation_errors

    when_i_choose_yes
    when_i_fill_out_the_role_start_date_fields
    and_i_click_save_and_continue
    then_i_see_the_employed_status_page

    when_i_click_save_and_continue
    then_i_see_employment_status_field_validation_errors

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_job_title_page

    when_i_visit_the_employment_status_page
    when_i_choose_employed
    and_i_click_save_and_continue
    then_i_see_the_job_title_page

    when_i_visit_the_employment_status_page
    when_i_choose_left
    and_i_click_save_and_continue
    then_i_see_reason_leaving_role_field_validation_errors

    when_i_visit_the_employment_status_page
    when_i_choose_left
    when_i_choose_resigned
    and_i_click_save_and_continue
    then_i_see_the_job_title_page

    when_i_visit_the_employment_status_page
    when_i_choose_left
    when_i_fill_out_the_role_end_date_fields
    when_i_choose_resigned
    and_i_click_save_and_continue

    # What’s their job title?

    then_i_see_the_job_title_page

    when_i_click_save_and_continue
    then_i_see_job_title_field_validation_errors

    when_i_fill_in_the_job_title_field
    when_i_click_save_and_continue

    # Do they work in the same organisation as you?

    then_i_see_the_same_organisation_page

    when_i_click_save_and_continue
    then_i_see_same_organisation_field_validation_errors

    when_i_choose_no
    when_i_click_save_and_continue
    then_i_see_the_duties_page

    when_i_visit_the_same_organisation_page
    and_i_choose_yes
    when_i_click_save_and_continue

    # How do you want to tell us about their main duties?

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
    then_i_see_the_check_answers_page

    when_i_visit_the_duties_page
    and_i_see_the_uploaded_filename
    and_i_choose_upload
    and_i_attach_a_second_job_description_file
    and_i_click_save_and_continue
    then_i_see_the_check_answers_page

    when_i_visit_the_duties_page
    and_i_see_the_second_uploaded_filename
    and_i_choose_details
    when_i_fill_in_the_duties_field
    and_i_click_save_and_continue

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

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
  end

  # Visit URLs

  def and_i_visit_a_referral
    @referral = create(:referral, user: @user)
    visit edit_referral_path(@referral)
  end

  def when_i_visit_the_employment_status_page
    visit referrals_edit_teacher_employment_status_path(@referral)
  end

  def when_i_visit_the_job_title_page
    visit referrals_edit_teacher_job_title_path(@referral)
  end

  def when_i_visit_the_same_organisation_page
    visit referrals_edit_teacher_same_organisation_path(@referral)
  end

  def when_i_visit_the_duties_page
    visit referrals_edit_teacher_duties_path(@referral)
  end

  def when_i_visit_the_check_answers_page
    visit referrals_edit_teacher_role_check_answers_path(@referral)
  end

  # Page URL/Title

  def then_i_see_the_referral_summary
    expect(page).to have_current_path("/referrals/#{@referral.id}/edit")
    expect(page).to have_title(
      "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def then_i_see_the_employed_status_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/employment-status"
    )
    expect(page).to have_title("Are they still employed in that job?")
    expect(page).to have_content("Are they still employed in that job?")
  end

  def then_i_see_the_job_title_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/job-title"
    )
    expect(page).to have_title("What’s their job title?")
    expect(page).to have_content("What’s their job title?")
  end

  def then_i_see_the_same_organisation_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/same-organisation"
    )
    expect(page).to have_title("Do they work in the same organisation as you?")
    expect(page).to have_content(
      "Do they work in the same organisation as you?"
    )
  end

  def then_i_see_the_duties_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/duties"
    )
    expect(page).to have_title(
      "How do you want to tell us about their main duties?"
    )
    expect(page).to have_content(
      "How do you want to tell us about their main duties?"
    )
  end

  def then_i_see_the_job_start_date_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/start-date"
    )
    expect(page).to have_title("Do you know when they started their job?")
    expect(page).to have_content("Do you know when they started their job?")
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/teacher-role/check-answers"
    )
    expect(page).to have_title("Check and confirm your answers")
    expect(page).to have_content("Check and confirm your answers")
  end

  # Clicks

  def when_i_edit_teacher_role_details
    within(all(".app-task-list__section")[1]) { click_on "About their role" }
  end

  def and_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :when_i_click_save_and_continue, :and_i_click_save_and_continue

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back

  # Radios

  def when_i_choose_yes
    choose "Yes", visible: false
  end
  alias_method :and_i_choose_yes, :when_i_choose_yes

  def when_i_choose_no
    choose "No", visible: false
  end

  def when_i_choose_employed
    choose "They are still employed but they’ve been suspended", visible: false
  end

  def when_i_choose_left
    choose "No, they have left the organisation", visible: false
  end

  def when_i_choose_resigned
    choose "Resigned", visible: false
  end

  def when_i_choose_upload
    choose "I’ll upload a job description", visible: false
  end
  alias_method :and_i_choose_upload, :when_i_choose_upload

  def when_i_choose_details
    choose "I’ll describe their main duties", visible: false
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
    fill_in "What’s their job title?", with: "Teacher"
  end

  def when_i_fill_in_the_duties_field
    fill_in "Describe their main duties", with: "Main duties"
  end

  # File uploads

  def and_i_attach_a_job_description_file
    attach_file(
      "Upload job description",
      File.absolute_path(Rails.root.join("spec/fixtures/files/file.pdf"))
    )
  end

  def and_i_attach_a_second_job_description_file
    attach_file(
      "Upload job description",
      File.absolute_path(Rails.root.join("spec/fixtures/files/file2.pdf"))
    )
  end

  # Validation errors

  def then_i_see_employment_status_field_validation_errors
    expect(page).to have_content(
      "Tell us if you know if they are still employed in that job"
    )
  end

  def then_i_see_reason_leaving_role_field_validation_errors
    expect(page).to have_content("Tell us how they left this job")
  end

  def then_i_see_role_start_date_known_field_validation_errors
    expect(page).to have_content("Tell us if you know their role start date")
  end

  def then_i_see_role_start_date_field_validation_errors
    expect(page).to have_content("Enter their role start date")
  end

  def then_i_see_role_end_date_field_validation_errors
    expect(page).to have_content(
      "Enter their role end date in the correct format"
    )
  end

  def then_i_see_job_title_field_validation_errors
    expect(page).to have_content("Enter their job title")
  end

  def then_i_see_same_organisation_field_validation_errors
    expect(page).to have_content(
      "Tell us if they work in the same organisation as you"
    )
  end

  def then_i_see_duties_format_field_validation_errors
    expect(page).to have_content(
      "Choose how you want to tell us about their main duties"
    )
  end

  def then_i_see_duties_upload_field_validation_errors
    expect(page).to have_content(
      "Select a file containing their job description"
    )
  end

  def then_i_see_duties_details_field_validation_errors
    expect(page).to have_content("Enter details of their main duties")
  end

  def then_i_see_a_completed_error
    expect(page).to have_content("Tell us if you have completed this section")
  end

  # Page content

  def and_i_see_the_uploaded_filename
    expect(page).to have_content("Uploaded file: file.pdf")
  end

  def and_i_see_the_second_uploaded_filename
    expect(page).to have_content("Uploaded file: file2.pdf")
  end

  def and_i_see_a_summary_list
    summary_rows = all(".govuk-summary-list__row")

    within(summary_rows[0]) do
      expect(find(".govuk-summary-list__key").text).to eq("Email address")
      expect(find(".govuk-summary-list__value").text).to eq("name@example.com")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: referrals_edit_contact_details_email_path(@referral)
      )
    end
  end

  def then_i_see_the_status_section_in_the_referral_summary(status: "COMPLETED")
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[2]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "About their role"
        )
        expect(find(".app-task-list__tag").text).to eq(status)
      end
    end
  end
end
