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

    when_i_have_more_evidence_to_upload
    and_i_click_save_and_continue
    then_i_am_asked_to_upload_evidence_files

    when_i_upload_more_evidence_files
    and_i_click_save_and_continue
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
    attach_file(
      "Upload files",
      [Rails.root.join("spec/fixtures/files/upload.txt")]
    )
  end

  def then_i_am_asked_to_confirm_the_evidence_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Uploaded evidence",
      value: "upload1.pdf\nupload2.pdf\nupload.txt"
    )
    expect(page).to have_link(
      "upload1.pdf",
      href:
        rails_blob_path(
          @referral.evidences.first.document,
          disposition: "attachment"
        )
    )

    expect(page).to have_link(
      "upload2.pdf",
      href:
        rails_blob_path(
          @referral.evidences.second.document,
          disposition: "attachment"
        )
    )

    expect(page).to have_link(
      "upload.txt",
      href:
        rails_blob_path(
          @referral.evidences.last.document,
          disposition: "attachment"
        )
    )
  end

  def then_i_am_asked_to_confirm_the_updated_evidence_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Do you have anything to upload?",
      value: "Yes",
      change_link:
        edit_referral_evidence_start_path(@referral, return_to: current_url)
    )

    expect_summary_row(
      key: "Uploaded evidence",
      value: "upload2.pdf\nupload.txt",
      change_link:
        edit_referral_evidence_uploaded_path(@referral, return_to: current_url)
    )
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Select yes if you???ve completed this section")
  end

  def and_i_click_delete_on_the_first_evidence_item
    within(page.find(".govuk-summary-list__row", text: "upload1.pdf")) do
      click_on "Delete"
    end
  end

  def then_i_am_asked_to_confirm_deletion
    expect(page).to have_content("Are you sure you want to delete upload1.pdf?")
  end

  def when_i_confirm_i_want_to_delete
    click_on "Yes I???m sure ??? delete it"
  end

  def then_i_can_no_longer_see_the_upload_in_the_list
    within(".govuk-summary-list") do
      expect(page).not_to have_link("upload1.pdf")
    end

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
    attach_file(
      "Upload files",
      [Rails.root.join("spec/fixtures/files/upload.txt")]
    )
  end

  def and_i_choose_to_confirm
    choose "Yes, I???ve completed this section", visible: false
  end

  def when_i_choose_not_to_confirm
    choose "No, I???ll come back to it later", visible: false
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
  alias_method :then_the_evidence_section_state_is,
               :and_the_evidence_section_state_is
end
