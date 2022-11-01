# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Personal details" do
  scenario "User adds personal details to a referral" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_i_am_making_a_referral

    when_i_edit_personal_details
    and_i_click_save_and_continue
    then_i_see_name_field_validation_errors

    when_i_fill_out_the_name_fields_and_save
    and_i_click_save_and_continue
    then_i_am_asked_if_i_know_their_date_of_birth

    and_i_click_save_and_continue
    then_i_see_age_field_validation_errors

    when_i_fill_out_their_date_of_birth
    and_i_click_save_and_continue

    then_the_section_summary_displays_the_saved_personal_details
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_i_am_making_a_referral
    @referral = Referral.create!
    visit edit_referral_path(@referral)

    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def when_i_edit_personal_details
    within(all(".app-task-list__section")[1]) { click_on "Personal details" }
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

  def then_i_am_asked_if_i_know_their_date_of_birth
    expect(page).to have_content("Do you know their age or date of birth?")
  end

  def then_i_see_age_field_validation_errors
    expect(page).to have_content(
      "Please indicate whether you know their date of birth or age"
    )
  end

  def when_i_fill_out_their_date_of_birth
    choose "I know their date of birth", visible: false
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end

  def then_the_section_summary_displays_the_saved_personal_details
    # TODO: This will assert the section summary page contents, not built yet
    @referral.reload
    expect(@referral.first_name).to eq("Jane")
    expect(@referral.last_name).to eq("Smith")
    expect(@referral.previous_name).to eq("Jane Jones")
    expect(@referral.date_of_birth).to eq(Date.new(1990, 1, 17))
  end
end
