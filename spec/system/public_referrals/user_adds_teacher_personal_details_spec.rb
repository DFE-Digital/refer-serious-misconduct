# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Personal details", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "A member of the public adds personal details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    and_i_visit_the_public_referral
    then_i_see_the_public_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_back
    then_i_see_the_public_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_see_name_field_validation_errors

    when_i_fill_out_the_name_fields_and_save
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_their_personal_details

    when_i_visit_the_referral
    when_i_edit_personal_details
    then_i_see_the_check_your_answers_page("Personal details", "teacher_personal_details")

    and_i_click_save_and_continue
    then_i_see_confirmation_validation_errors

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_i_see_personal_details_flagged_as_incomplete

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
    expect(page).to have_content("There’s a problem")
  end

  def when_i_fill_out_the_name_fields_and_save
    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Smith"
    find("label", text: "Yes").click
    fill_in "Other name", with: "Jane Jones"
  end

  def then_i_am_asked_to_confirm_their_personal_details
    expect(page).to have_content("Personal details")
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Their name",
      value: "Jane Smith",
      change_link:
        edit_public_referral_teacher_personal_details_name_path(@referral, return_to: current_path)
    )

    expect(page).to have_content("Have you completed this section?")
  end

  def then_i_see_confirmation_validation_errors
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def when_i_confirm_their_personal_details
    find("label", text: "Yes, I’ve completed this section").click
  end

  def then_i_see_the_completed_section_in_the_referral_summary
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq("Personal details")
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end
end
