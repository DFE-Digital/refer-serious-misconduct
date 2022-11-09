# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Personal details", type: :system do
  scenario "User adds personal details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_visit_a_referral
    then_i_see_the_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_back
    then_i_see_the_referral_summary

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_see_name_field_validation_errors

    when_i_fill_out_the_name_fields_and_save
    and_i_click_save_and_continue
    then_i_am_asked_their_date_of_birth

    when_i_click_back
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_am_asked_their_date_of_birth

    and_i_click_save_and_continue
    then_i_see_age_field_validation_errors

    when_i_fill_out_their_date_of_birth
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_trn

    when_i_click_back
    then_i_am_asked_their_date_of_birth

    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_trn

    and_i_click_save_and_continue
    then_i_see_trn_field_validation_errors

    when_i_fill_out_their_trn
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_whether_they_have_qts

    when_i_click_back
    then_i_am_asked_if_i_know_their_trn
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_whether_they_have_qts

    and_i_click_save_and_continue
    then_i_see_qts_field_validation_errors

    when_i_fill_out_their_qts
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_their_personal_details

    when_i_click_back
    then_i_am_asked_if_i_know_whether_they_have_qts
    and_i_click_save_and_continue
    then_i_am_asked_to_confirm_their_personal_details

    and_i_click_save_and_continue
    then_i_see_confirmation_validation_errors

    when_i_confirm_their_personal_details
    and_i_click_save_and_continue
    then_i_see_the_completed_section_in_the_referral_summary
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
    @referral = Referral.create!
    visit edit_referral_path(@referral)
  end

  def when_i_edit_personal_details
    within(all(".app-task-list__section")[1]) { click_on "Personal details" }
  end

  def and_i_am_asked_their_name
    expect(page).to have_content(
      "What is the name of the person you’re referring?"
    )
  end

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back

  def then_i_see_the_referral_summary
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def then_i_see_name_field_validation_errors
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
  end

  def when_i_fill_out_the_name_fields_and_save
    fill_in "First name", with: "Jane"
    fill_in "Last name", with: "Smith"
    choose "Yes", visible: false
    fill_in "Previous name", with: "Jane Jones"
  end

  def and_i_click_save_and_continue
    click_on "Save and continue"
  end

  def then_i_am_asked_their_date_of_birth
    expect(page).to have_content("Do you know their date of birth?")
  end

  def then_i_see_age_field_validation_errors
    expect(page).to have_content("Tell us if you know their date of birth")
  end

  def when_i_fill_out_their_date_of_birth
    choose "I know their date of birth", visible: false
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end

  def then_i_am_asked_if_i_know_their_trn
    expect(page).to have_content(
      "Do you know their teacher reference number (TRN)?"
    )
    expect(page).to have_content("A TRN is 7 digits long, for example 4567814.")
  end

  def then_i_see_trn_field_validation_errors
    expect(page).to have_content("Tell us if you know their TRN number")
  end

  def when_i_fill_out_their_trn
    choose "Yes", visible: false
    fill_in "Teacher reference number", with: "RP99/12345"
  end

  def then_i_am_asked_if_i_know_whether_they_have_qts
    expect(page).to have_content("Do they have qualified teacher status (QTS)?")
  end

  def then_i_see_qts_field_validation_errors
    expect(page).to have_content("Tell us if you know whether they have QTS")
  end

  def when_i_fill_out_their_qts
    choose "Yes", visible: false
  end

  def then_i_am_asked_to_confirm_their_personal_details
    expect(page).to have_content("About the person you are referring")
    expect(page).to have_content("Personal details")

    summary_rows = all(".govuk-summary-list__row")

    within(summary_rows[0]) do
      expect(find(".govuk-summary-list__key").text).to eq("Name")
      expect(find(".govuk-summary-list__value").text).to eq("Jane Smith")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: referrals_edit_personal_details_name_path(@referral)
      )
    end

    within(summary_rows[1]) do
      expect(find(".govuk-summary-list__key").text).to eq("Date of birth")
      expect(find(".govuk-summary-list__value").text).to eq("17 January 1990")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: referrals_edit_personal_details_age_path(@referral)
      )
    end

    within(summary_rows[2]) do
      expect(find(".govuk-summary-list__key").text).to eq(
        "Teacher reference number (TRN)"
      )
      expect(find(".govuk-summary-list__value").text).to eq("9912345")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: referrals_edit_personal_details_trn_path(@referral)
      )
    end

    within(summary_rows[3]) do
      expect(find(".govuk-summary-list__key").text).to eq("Do they have QTS?")
      expect(find(".govuk-summary-list__value").text).to eq("Yes")
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: referrals_edit_personal_details_qts_path(@referral)
      )
    end

    expect(page).to have_content("Have you completed this section?")
  end

  def then_i_see_confirmation_validation_errors
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def when_i_confirm_their_personal_details
    choose "Yes, I’ve completed this section", visible: false
  end

  def then_i_see_the_completed_section_in_the_referral_summary
    within(all(".app-task-list__section")[1]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq(
          "Personal details"
        )
        expect(find(".app-task-list__tag").text).to eq("COMPLETED")
      end
    end
  end
end
