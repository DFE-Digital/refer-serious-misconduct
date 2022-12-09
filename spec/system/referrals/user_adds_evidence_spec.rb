# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Evidence", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "User adds evidence to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_visit_the_referral
    then_i_see_the_referral_summary

    when_i_edit_the_evidence
    then_i_am_asked_if_i_have_evidence_to_upload

    when_i_click_save_and_continue
    then_i_see_evidence_start_form_validation_errors

    when_i_choose_yes_to_uploading_evidence
    and_i_click_save_and_continue
    then_i_am_asked_to_upload_evidence_files

    when_i_click_save_and_continue
    then_i_see_evidence_upload_form_validation_errors

    when_i_upload_evidence_files
    and_i_click_save_and_continue
    then_i_see_a_list_of_the_uploaded_files

    when_i_click_save_and_continue
    then_i_am_asked_to_choose_categories_for_the_first_item

    when_i_click_save_and_continue
    then_i_see_categories_form_validation_errors

    when_i_choose_categories_for_the_first_item
    and_i_click_save_and_continue
    then_i_am_asked_to_choose_categories_for_the_second_item

    when_i_click_back
    then_i_am_asked_to_choose_categories_for_the_first_item

    when_i_click_save_and_continue
    then_i_am_asked_to_choose_categories_for_the_second_item

    when_i_choose_categories_for_the_second_item
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_evidence_details

    when_i_click_change_categories_for_the_first_item
    then_i_am_asked_to_choose_categories_for_the_first_item
    when_i_click_back
    then_i_am_asked_to_confirm_the_evidence_details

    when_i_click_save_and_continue
    then_i_see_check_answers_form_validation_errors

    when_i_click_delete_on_the_first_evidence_item
    then_i_am_asked_to_confirm_deletion

    when_i_confirm_i_want_to_delete
    then_i_can_no_longer_see_the_upload_in_the_referral_summary

    when_i_choose_not_to_confirm
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_the_evidence_section_state_is(:incomplete)

    when_i_edit_the_evidence
    and_i_choose_to_confirm
    and_i_click_save_and_continue
    then_the_evidence_section_state_is(:completed)
  end

  private

  def when_i_edit_the_evidence
    within(all(".app-task-list__section")[2]) do
      click_on "Evidence and supporting information"
    end
  end

  def then_i_am_asked_if_i_have_evidence_to_upload
    expect(page).to have_content("Evidence and supporting information")
  end

  def then_i_see_evidence_start_form_validation_errors
    expect(page).to have_content("Tell us if you have evidence to upload")
  end

  def when_i_choose_yes_to_uploading_evidence
    choose "Yes, I need to upload files", visible: false
  end

  def when_i_choose_no_to_uploading_evidence
    choose "No, I do not have anything to upload", visible: false
  end

  def then_i_am_asked_to_upload_evidence_files
    expect(page).to have_content("Upload evidence and supporting information")
  end

  def then_i_see_evidence_upload_form_validation_errors
    expect(page).to have_content("Select evidence to upload")
  end

  def when_i_upload_evidence_files
    attach_file(
      "Upload files",
      [
        Rails.root.join("test/fixtures/files/doc2.pdf"),
        Rails.root.join("test/fixtures/files/doc1.pdf")
      ]
    )
  end

  def then_i_see_a_list_of_the_uploaded_files
    expect(page).to have_content("You uploaded 2 files")
    within(".govuk-list") do
      expect(page).to have_link("doc1.pdf")
      expect(page).to have_link("doc2.pdf")
    end
  end

  def then_i_am_asked_to_choose_categories_for_the_first_item
    expect(page).to have_content("Your uploaded file")
    expect(page).to have_content("doc1.pdf")
    expect(page).to have_content(
      "Select all the categories that describe this file"
    )
  end

  def then_i_see_categories_form_validation_errors
    expect(page).to have_content("Select categories that describe this file")
  end

  def when_i_choose_categories_for_the_first_item
    check "CV", visible: false
    check "Job offer", visible: false
    check "Signed witness statements", visible: false
  end

  def then_i_am_asked_to_choose_categories_for_the_second_item
    expect(page).to have_content("Your uploaded file")
    expect(page).to have_content("doc2.pdf")
    expect(page).to have_content(
      "Select all the categories that describe this file"
    )
  end

  def when_i_choose_categories_for_the_second_item
    check "Police investigation and reports", visible: false
    check "Other", visible: false
    fill_in "Explain what this document is", with: "Some other details"
  end

  def then_i_am_asked_to_confirm_the_evidence_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "doc1.pdf",
      value: "CV, Job offer, Signed witness statements"
    )
    expect(page).to have_link(
      "doc1.pdf",
      href:
        rails_blob_path(
          @referral.evidences.first.document,
          disposition: "attachment"
        )
    )

    expect_summary_row(
      key: "doc2.pdf",
      value: "Police investigation and reports, Other: Some other details"
    )
    expect(page).to have_link(
      "doc2.pdf",
      href:
        rails_blob_path(
          @referral.evidences.second.document,
          disposition: "attachment"
        )
    )
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def when_i_click_delete_on_the_first_evidence_item
    within(page.find(".govuk-summary-list__row", text: "doc1.pdf")) do
      click_on "Delete"
    end
  end

  def then_i_am_asked_to_confirm_deletion
    expect(page).to have_content("Are you sure you want to delete doc1.pdf?")
  end

  def when_i_confirm_i_want_to_delete
    click_on "Yes I’m sure – delete it"
  end

  def then_i_can_no_longer_see_the_upload_in_the_referral_summary
    expect_summary_row(
      key: "doc2.pdf",
      value: "Police investigation and reports, Other: Some other details"
    )
  end

  def and_i_choose_to_confirm
    choose "Yes, I’ve completed this section", visible: false
  end

  def when_i_choose_not_to_confirm
    choose "No, I’ll come back to it later", visible: false
  end

  def and_the_evidence_section_state_is(state)
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[2]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Evidence and supporting information"
        )
        expect(find(".app-task-list__tag").text).to eq(state.to_s.upcase)
      end
    end
  end
  alias_method :then_the_evidence_section_state_is,
               :and_the_evidence_section_state_is

  def when_i_click_change_categories_for_the_first_item
    click_on "Change categories", match: :first
  end
end
