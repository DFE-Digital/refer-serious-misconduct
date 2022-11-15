# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Allegation", type: :system do
  scenario "User adds an allegation to a referral" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_visit_a_referral
    then_i_see_the_referral_summary

    when_i_edit_the_allegation
    then_i_am_asked_how_i_want_to_make_the_allegation

    when_i_click_save_and_continue
    then_i_see_allegation_form_validation_errors

    when_i_fill_out_allegation_details
    and_i_click_save_and_continue
    then_i_am_asked_to_summarise_what_happened
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

  def when_i_edit_the_allegation
    within(all(".app-task-list__section")[2]) { click_on "Details of the allegation" }
  end

  def then_i_am_asked_how_i_want_to_make_the_allegation
    expect(page).to have_content("How do you want to tell us about your allegation?")
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def then_i_see_allegation_form_validation_errors
    expect(page).to have_content("Choose how you want to tell us about your allegation")
  end

  def when_i_fill_out_allegation_details
    choose "I’ll give details of the allegation", visible: false
    fill_in "Details of the allegation", with: "Something something something"
  end

  def then_i_am_asked_to_summarise_what_happened
  end
end
