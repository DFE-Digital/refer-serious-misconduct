# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Teacher role", type: :system do
  scenario "User adds teacher role details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_visit_a_referral
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    then_i_am_asked_their_role_start_date
    and_i_click_back
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    then_i_am_asked_their_role_start_date
    and_i_click_save_and_continue
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
    then_i_see_the_job_title_page

    when_i_click_save_and_continue
    then_i_see_job_title_field_validation_errors

    when_i_fill_in_the_job_title_field
    when_i_click_save_and_continue
    then_i_see_the_same_organisation_page

    when_i_click_save_and_continue
    then_i_see_same_organisation_field_validation_errors

    when_i_choose_no
    when_i_click_save_and_continue
    then_i_see_the_referral_summary

    when_i_visit_the_same_organisation_page
    and_i_choose_yes
    when_i_click_save_and_continue
    then_i_see_the_referral_summary
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

  def when_i_edit_teacher_role_details
    within(all(".app-task-list__section")[1]) { click_on "About their role" }
  end

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back

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

  def and_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :when_i_click_save_and_continue, :and_i_click_save_and_continue

  def then_i_am_asked_their_role_start_date
    expect(page).to have_content("Do you know when they started their job?")
  end

  def then_i_see_role_start_date_known_field_validation_errors
    expect(page).to have_content("Tell us if you know their role start date")
  end

  def then_i_see_role_start_date_field_validation_errors
    expect(page).to have_content("Enter their role start date")
  end

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

  def when_i_fill_out_the_role_start_date_fields
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end
  alias_method :when_i_fill_out_the_role_end_date_fields,
               :when_i_fill_out_the_role_start_date_fields

  def then_i_see_employment_status_field_validation_errors
    expect(page).to have_content(
      "Tell us if you know if they are still employed in that job"
    )
  end

  def then_i_see_reason_leaving_role_field_validation_errors
    expect(page).to have_content("Tell us how they left this job")
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

  def when_i_fill_in_the_job_title_field
    fill_in "What’s their job title?", with: "Teacher"
  end
end
