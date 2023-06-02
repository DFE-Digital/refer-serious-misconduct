# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Evidence", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "A member of public adds evidence to referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    and_i_visit_the_public_referral
    then_i_see_the_public_referral_summary

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

    when_i_visit_the_referral
    when_i_edit_the_evidence
    then_i_see_the_check_your_answers_page(
      "Evidence and supporting information",
      "allegation_evidence"
    )

    when_i_click_on_change_evidence
    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue
    and_i_change_anything_to_upload_to_no
    and_i_click_save_and_continue
    and_i_visit_uploaded_files
    then_the_list_of_the_uploaded_files_should_be_empty

    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue
    and_i_change_anything_to_upload_to_yes
    when_i_choose_yes_to_uploading_evidence
    and_i_click_save_and_continue
    when_i_upload_evidence_files
    and_i_click_save_and_continue
    then_i_see_a_list_of_the_uploaded_files

    when_i_have_more_evidence_to_upload
    and_i_click_save_and_continue
    then_i_am_asked_to_upload_evidence_files

    when_i_upload_more_evidence_files
    and_i_click_save_and_continue
    then_i_see_a_list_of_the_uploaded_files

    and_i_visit_the_public_referral
    when_i_edit_the_evidence
    when_i_click_change_uploaded_evidence
    then_i_see_a_list_of_the_uploaded_files

    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_evidence_details

    when_i_click_save_and_continue
    then_i_see_check_answers_form_validation_errors

    when_i_click_change_uploaded_evidence
    and_i_click_delete_on_the_first_evidence_item
    then_i_am_asked_to_confirm_deletion

    when_i_confirm_i_want_to_delete
    then_i_can_no_longer_see_the_upload_in_the_list

    when_i_continue_to_the_evidence_summary_page
    and_i_click_add_more_evidence
    and_i_upload_more_evidence
    and_i_click_save_and_continue
    then_i_see_a_list_of_the_updated_files

    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_updated_evidence_details

    when_i_choose_not_to_confirm
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_the_evidence_section_state_is(:incomplete)

    when_i_edit_the_evidence
    when_i_click_change_uploaded_evidence
    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue

    when_i_visit_the_referral
    and_i_click_review_and_send
    then_i_see_the_section_completion_message(
      "Evidence and supporting information",
      "allegation_evidence"
    )

    when_i_click_on_complete_section("Evidence and supporting information")
    and_i_choose_complete
    and_i_click_save_and_continue
    and_the_evidence_section_state_is(:completed)

    when_i_click_review_and_send
    then_i_see_the_complete_section("Evidence and supporting information")
  end

  private

  def when_i_edit_the_evidence
    within(all(".app-task-list__section")[2]) { click_on "Evidence and supporting information" }
  end

  def then_i_am_asked_if_i_have_evidence_to_upload
    expect(page).to have_content("Evidence and supporting information")
    expect(page).to have_content("complaint made to the school")
  end

  def then_i_see_evidence_start_form_validation_errors
    expect(page).to have_content("Select yes if you have evidence to upload")
  end

  def when_i_choose_yes_to_uploading_evidence
    choose "Yes", visible: false
  end

  def when_i_choose_no_to_uploading_evidence
    choose "No", visible: false
  end

  def then_i_am_asked_to_upload_evidence_files
    expect(page).to have_content("Evidence and supporting information")
    expect(page).to have_content("Upload evidence")
  end

  def then_i_see_evidence_upload_form_validation_errors
    expect(page).to have_content("Select evidence to upload")
  end

  def when_i_upload_evidence_files
    attach_file(
      "Upload files",
      [
        Rails.root.join("spec/fixtures/files/upload2.pdf"),
        Rails.root.join("spec/fixtures/files/upload1.pdf")
      ]
    )
  end

  def then_i_see_a_list_of_the_uploaded_files
    expect(page).to have_content("Uploaded evidence")
    within(".govuk-summary-list") do
      expect(page).to have_link("upload1.pdf")
      expect(page).to have_link("upload2.pdf")
    end
  end

  def then_i_see_a_list_of_the_updated_files
    expect(page).to have_content("Uploaded evidence")

    within(".govuk-summary-list") do
      expect(page).to have_link("upload2.pdf")
      expect(page).to have_link("upload.txt")
    end
  end

  def when_i_have_more_evidence_to_upload
    choose "Yes", visible: false
  end

  def when_i_have_no_more_evidence_to_upload
    choose "No", visible: false
  end

  def when_i_upload_more_evidence_files
    attach_file("Upload files", [Rails.root.join("spec/fixtures/files/upload.txt")])
  end

  def then_i_am_asked_to_confirm_the_evidence_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(key: "Uploaded evidence", value: "upload1.pdf\nupload2.pdf\nupload.txt")
    expect(page).to have_link(
      "upload1.pdf",
      href: rails_blob_path(@referral.evidence_uploads.first.file, disposition: "attachment")
    )

    expect(page).to have_link(
      "upload2.pdf",
      href: rails_blob_path(@referral.evidence_uploads.second.file, disposition: "attachment")
    )

    expect(page).to have_link(
      "upload.txt",
      href: rails_blob_path(@referral.evidence_uploads.last.file, disposition: "attachment")
    )
  end

  def then_i_am_asked_to_confirm_the_updated_evidence_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Do you have anything to upload?",
      value: "Yes",
      change_link:
        edit_public_referral_allegation_evidence_start_path(@referral, return_to: current_path)
    )

    expect_summary_row(
      key: "Uploaded evidence",
      value: "upload2.pdf\nupload.txt",
      change_link:
        edit_public_referral_allegation_evidence_uploaded_path(@referral, return_to: current_path)
    )
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def and_i_click_delete_on_the_first_evidence_item
    within(page.find(".govuk-summary-list__row", text: "upload1.pdf")) { click_on "Delete" }
  end

  def then_i_am_asked_to_confirm_deletion
    expect(page).to have_content("Confirm that you want to delete upload1.pdf?")
  end

  def when_i_confirm_i_want_to_delete
    click_on "Yes I’m sure – delete it"
  end

  def then_i_can_no_longer_see_the_upload_in_the_list
    within(".govuk-summary-list") { expect(page).not_to have_link("upload1.pdf") }

    expect_summary_row(key: "File 1", value: "upload2.pdf")
  end

  def when_i_continue_to_the_evidence_summary_page
    when_i_have_no_more_evidence_to_upload
    and_i_click_save_and_continue
  end

  def and_i_click_add_more_evidence
    click_on "Add more evidence"
  end

  def and_i_upload_more_evidence
    attach_file("Upload files", [Rails.root.join("spec/fixtures/files/upload.txt")])
  end

  def and_i_choose_to_confirm
    choose "Yes, I’ve completed this section", visible: false
  end

  def when_i_choose_not_to_confirm
    choose "No, I’ll come back to it later", visible: false
  end

  def when_i_click_change_uploaded_evidence
    within(all(".govuk-summary-list__actions")[1]) { click_on "Change" }
  end

  def and_the_evidence_section_state_is(state)
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[1]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Evidence and supporting information"
        )
        expect(find(".app-task-list__tag").text).to eq(state.to_s.upcase)
      end
    end
  end
  alias_method :then_the_evidence_section_state_is, :and_the_evidence_section_state_is

  def and_i_change_anything_to_upload_to_no
    click_on "Change if you have anything to upload"
    choose "No", visible: false
  end

  def and_i_change_anything_to_upload_to_yes
    click_on "Change"
    choose "Yes", visible: false
  end

  def and_i_visit_uploaded_files
    visit edit_public_referral_allegation_evidence_uploaded_path(@referral)
  end

  def then_the_list_of_the_uploaded_files_should_be_empty
    expect(page).to have_content("Uploaded evidence")
    within(".govuk-summary-list") do
      expect(page).not_to have_link("upload1.pdf")
      expect(page).not_to have_link("upload2.pdf")
    end
  end

  def when_i_click_on_change_evidence
    click_on "Change if you have anything to upload"
  end
end
