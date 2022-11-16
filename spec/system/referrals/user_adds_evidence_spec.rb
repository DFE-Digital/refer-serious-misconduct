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

    when_i_choose_no_to_uploading_evidence
    and_i_click_save_and_continue
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

  def when_i_choose_no_to_uploading_evidence
    choose "No, I do not have anything to upload", visible: false
  end
end
