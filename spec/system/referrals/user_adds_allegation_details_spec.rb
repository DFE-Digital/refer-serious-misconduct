# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Allegation", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "User adds an allegation to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_visit_the_referral
    then_i_see_the_referral_summary

    when_i_edit_the_allegation
    then_i_am_asked_how_i_want_to_make_the_allegation

    when_i_click_save_and_continue
    then_i_see_allegation_form_validation_errors

    when_i_fill_out_allegation_details
    and_i_click_save_and_continue
    then_i_am_asked_if_i_have_notified_dbs

    # Check answers redirection after first question
    when_i_visit_the_referral
    when_i_edit_the_allegation
    then_i_see_the_allegation_check_your_answers_page

    when_i_click_on_complete_your_details
    when_i_click_save_and_continue
    then_i_see_dbs_form_validation_errors

    when_i_choose_i_have_notified_dbs
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_allegation_details

    when_i_click_change_allegation_details
    then_i_am_asked_how_i_want_to_make_the_allegation

    when_i_choose_upload_the_allegation
    and_i_click_save_and_continue
    then_i_am_asked_to_upload_an_allegation_file

    when_i_click_save_and_continue
    then_i_see_the_upload_form_validation_errors

    when_i_upload_the_allegation
    and_i_click_save_and_continue
    then_i_see_the_uploaded_filename

    when_i_click_save_and_continue
    then_i_see_check_answers_form_validation_errors

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_the_allegation_section_is_incomplete
    and_i_click_review_and_send
    then_i_see_the_section_completion_message("Details of the allegation", "allegation")

    when_i_click_on_complete_section("Details of the allegation")
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_the_allegation_section_is_complete

    when_i_click_review_and_send
    then_i_see_the_complete_section("Details of the allegation")
  end

  private

  def when_i_edit_the_allegation
    within(all(".app-task-list__section")[2]) { click_on "Details of the allegation" }
  end

  def then_i_am_asked_how_i_want_to_make_the_allegation
    expect(page).to have_content("How do you want to give details about the allegation?")
  end

  def then_i_see_allegation_form_validation_errors
    expect(page).to have_content("There’s a problem")
  end

  def when_i_fill_out_allegation_details
    choose "Describe the allegation", visible: false
    fill_in "Description of the allegation", with: "Something something something"
  end

  def then_i_am_asked_if_i_have_notified_dbs
    expect(page).to have_content("Telling DBS about this case")
  end

  def then_i_see_dbs_form_validation_errors
    expect(page).to have_content("There’s a problem")
  end

  def when_i_choose_i_have_notified_dbs
    choose "Yes, I’ve told DBS", visible: false
  end

  def then_i_am_asked_to_confirm_the_allegation_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "How do you want to give details about the allegation?",
      value: "Describe the allegation"
    )

    expect_summary_row(
      key: "Description of the allegation",
      value: "Something something something",
      change_link: edit_referral_allegation_details_path(@referral, return_to: current_path)
    )

    expect_summary_row(
      key: "Have you told DBS?",
      value: "Yes",
      change_link: edit_referral_allegation_dbs_path(@referral, return_to: current_path)
    )
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def when_i_choose_to_confirm
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_the_allegation_section_is_complete
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq("Details of the allegation")
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end

  def when_i_click_change_allegation_details
    click_on "Change description of the allegation"
  end

  def when_i_click_on_change_notified_dbs
    click_on "Change if you have told DBS"
  end

  def when_i_choose_upload_the_allegation
    choose "Upload file", visible: false
  end

  def then_i_am_asked_to_upload_an_allegation_file
    expect(page).to have_content("Upload file")
  end

  def then_i_see_the_upload_form_validation_errors
    expect(page).to have_content("Select a file containing details of your allegation")
  end

  def then_i_see_the_uploaded_filename
    expect(page).to have_content("upload1.pdf")
  end

  def when_i_upload_the_allegation
    attach_file("Upload file", [Rails.root.join("spec/fixtures/files/upload1.pdf")])
  end

  def then_i_see_the_allegation_check_your_answers_page
    expect(page).to have_current_path(
      "/#{@referral.routing_scope && "public-"}referrals/#{@referral.id}/allegation/check-answers/edit"
    )
    expect(page).to have_title(
      "Check and confirm your answers - The allegation - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("The allegation")
    expect(page).to have_content("Check and confirm your answers")
  end
end
