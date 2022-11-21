# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Evidence", type: :system do
  scenario "User adds evidence to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_visit_a_referral
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

    when_i_choose_categories_for_the_second_item
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_evidence_details

    when_i_click_save_and_continue
    then_i_see_confirm_form_validation_errors

    when_i_choose_to_confirm
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_the_evidence_section_is_complete
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

  def then_i_see_the_referral_summary
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def when_i_edit_the_evidence
    within(all(".app-task-list__section")[2]) do
      click_on "Evidence and supporting information"
    end
  end

  def then_i_am_asked_if_i_have_evidence_to_upload
    expect(page).to have_content("Evidence and supporting information")
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def then_i_see_evidence_start_form_validation_errors
    expect(page).to have_content("Tell us if you have evidence to upload")
  end

  def when_i_choose_yes_to_uploading_evidence
    choose "Yes, I need to upload files", visible: false
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
        Rails.root.join("test/fixtures/files/doc1.pdf"),
        Rails.root.join("test/fixtures/files/doc2.pdf")
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

    within(all(".govuk-summary-list__row")[0]) do
      expect(find(".govuk-summary-list__key").text).to eq("doc1.pdf")
      expect(find(".govuk-summary-list__value").text).to eq(
        "CV, Job offer, Signed witness statements"
      )
    end

    within(all(".govuk-summary-list__row")[1]) do
      expect(find(".govuk-summary-list__key").text).to eq("doc2.pdf")
      expect(find(".govuk-summary-list__value").text).to eq(
        "Police investigation and reports, Other: Some other details"
      )
    end
  end

  def then_i_see_confirm_form_validation_errors
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def when_i_choose_to_confirm
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_the_evidence_section_is_complete
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[2]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Evidence and supporting information"
        )
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end
end
