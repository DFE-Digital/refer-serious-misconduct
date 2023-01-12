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
end
