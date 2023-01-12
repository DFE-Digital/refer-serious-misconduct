# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Details of the allegation", type: :system do
  include CommonSteps
  include SummaryListHelpers

  scenario "A member of the public adds details of the allegation to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    and_i_visit_the_public_referral
    then_i_see_the_public_referral_summary

    when_i_edit_details_of_the_allegation
    then_i_am_asked_how_i_want_to_make_the_allegation

    when_i_click_save_and_continue
    then_i_see_allegation_form_validation_errors

    when_i_fill_out_allegation_details
    and_i_click_save_and_continue
    then_i_am_asked_how_the_complaint_has_been_considered

    when_i_click_save_and_continue
    then_i_see_the_allegation_considerations_form_validation_errors

    when_i_fill_out_allegation_considerations
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_the_allegation_details

    when_i_click_save_and_continue
    then_i_see_check_answers_form_validation_errors

    when_i_choose_to_confirm
    and_i_click_save_and_continue
    then_i_see_the_public_referral_summary
    and_the_allegation_section_is_complete
  end

  private

  def when_i_edit_details_of_the_allegation
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
    expect(page).to have_content("There is a problem")
  end

  def when_i_fill_out_allegation_details
    choose "I’ll give details of the allegation", visible: false
    fill_in "Details of the allegation", with: "Something something something"
  end

  def then_i_am_asked_how_the_complaint_has_been_considered
    expect(page).to have_content("How has this complaint been considered?")
  end

  def then_i_see_the_allegation_considerations_form_validation_errors
    expect(page).to have_content("There is a problem")
  end

  def then_i_am_asked_to_confirm_the_allegation_details
    expect(page).to have_content("Check and confirm your answers")
    expect_summary_row(
      key: "How do you want to give details about the allegation?",
      value: "Describe the allegation",
      change_link:
        edit_public_referral_allegation_details_path(
          @referral,
          return_to: current_path
        )
    )

    expect_summary_row(
      key: "Description of the allegation",
      value: "Something something something",
      change_link:
        edit_public_referral_allegation_details_path(
          @referral,
          return_to: current_path
        )
    )

    expect_summary_row(
      key: "Details about how this complaint has been considered",
      value: "considered stuff",
      change_link:
        edit_public_referral_allegation_considerations_path(
          @referral,
          return_to: current_path
        )
    )
  end

  def when_i_fill_out_allegation_considerations
    fill_in "Details about how this complaint has been considered",
            with: "considered stuff"
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
        expect(find(".app-task-list__task-name a").text).to eq(
          "Details of the allegation"
        )
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end

  def then_i_see_the_public_referral_summary
    expect(page).to have_current_path(edit_public_referral_path(@referral))
  end
end
