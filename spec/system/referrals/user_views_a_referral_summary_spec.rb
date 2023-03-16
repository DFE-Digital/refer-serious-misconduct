# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User views an existing referral summary", type: :system do
  include CommonSteps

  scenario "Views referral summary sections" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral
    then_i_see_the_referral_as_sections
  end

  private

  def then_i_see_the_referral_as_sections
    expect(page).to have_content("Your referral")

    within(all(".app-task-list__section").first) { expect(page).to have_content("About you") }

    within(all(".app-task-list__section")[1]) { expect(page).to have_content("About the teacher") }

    within(all(".app-task-list__section").last) { expect(page).to have_content("The allegation") }
  end
end
