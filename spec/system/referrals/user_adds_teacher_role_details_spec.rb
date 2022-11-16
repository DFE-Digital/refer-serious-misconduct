# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Teacher role", type: :system do
  scenario "User adds teacher role details to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_visit_a_referral
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    then_i_am_asked_their_role_start_date
    and_i_click_back
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    then_i_am_asked_their_role_start_date
    and_i_click_save_and_continue
    then_i_see_role_start_date_known_field_validation_errors

    when_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_referral_summary

    when_i_edit_teacher_role_details
    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_role_start_date_field_validation_errors

    when_i_choose_yes
    when_i_fill_out_the_role_start_date_fields
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
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

  def when_i_edit_teacher_role_details
    within(all(".app-task-list__section")[1]) { click_on "About their role" }
  end

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back

  def then_i_see_the_referral_summary
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def and_i_click_save_and_continue
    click_on "Save and continue"
  end

  def then_i_am_asked_their_role_start_date
    expect(page).to have_content("Do you know when they started their job?")
  end

  def then_i_see_role_start_date_known_field_validation_errors
    expect(page).to have_content("Tell us if you know their role start date")
  end

  def then_i_see_role_start_date_field_validation_errors
    expect(page).to have_content("Enter their role start date")
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_choose_no
    choose "No", visible: false
  end

  def when_i_fill_out_the_role_start_date_fields
    fill_in "Day", with: "17"
    fill_in "Month", with: "1"
    fill_in "Year", with: "1990"
  end
end
