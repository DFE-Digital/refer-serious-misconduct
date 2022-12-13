# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Allegation", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "User adds an allegation to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
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

    when_i_click_save_and_continue
    then_i_see_dbs_form_validation_errors

    when_i_choose_i_have_notified_dbs
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_allegation_details

    when_i_click_save_and_continue
    then_i_see_check_answers_form_validation_errors

    when_i_choose_to_confirm
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_the_allegation_section_is_complete
  end

  private

  def when_i_edit_the_allegation
    within(all(".app-task-list__section")[2]) do
      click_on "Details of the allegation"
    end
  end

  def then_i_am_asked_how_i_want_to_make_the_allegation
    expect(page).to have_content(
      "How do you want to tell us about your allegation?"
    )
  end

  def then_i_see_allegation_form_validation_errors
    expect(page).to have_content(
      "Choose how you want to tell us about your allegation"
    )
  end

  def when_i_fill_out_allegation_details
    choose "I’ll give details of the allegation", visible: false
    fill_in "Details of the allegation", with: "Something something something"
  end

  def then_i_am_asked_if_i_have_notified_dbs
    expect(page).to have_content("Telling DBS about this case")
  end

  def then_i_see_dbs_form_validation_errors
    expect(page).to have_content(
      "Tell us if you have notified DBS about the case"
    )
  end

  def when_i_choose_i_have_notified_dbs
    choose "Yes, I’ve told DBS", visible: false
  end

  def then_i_am_asked_to_confirm_the_allegation_details
    expect(page).to have_content("Check and confirm your answers")

    expect_summary_row(
      key: "Summary",
      value: "Something something something",
      change_link:
        edit_referral_allegation_details_path(@referral, return_to: current_url)
    )

    expect_summary_row(
      key: "Have you told DBS?",
      value: "Yes",
      change_link:
        referrals_edit_allegation_dbs_path(@referral, return_to: current_url)
    )
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def when_i_choose_to_confirm
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_the_allegation_section_is_complete
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Details of the allegation"
        )
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end
end
