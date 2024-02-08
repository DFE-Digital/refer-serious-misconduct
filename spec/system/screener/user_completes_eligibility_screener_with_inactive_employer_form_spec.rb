# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Eligibility screener", type: :system do
  include CommonSteps

  scenario "User completes eligibility screener, inactive employer form" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_inactive
    when_i_visit_the_service
    when_i_complete_the_screener
    then_i_see_links_to_the_referral_form_documents
    and_event_tracking_is_working
  end

  def and_the_referral_form_feature_is_inactive
    FeatureFlags::FeatureFlag.deactivate(:referral_form)
  end

  def when_i_visit_the_service
    visit root_path
  end

  def when_i_complete_the_screener
    find("label", text: "I’m referring as an employer").click
    click_on "Continue"

    4.times do
      find("label", text: "I’m not sure").click
      click_on "Continue"
    end

    # /you-should-know
    click_on "I understand and want to continue"
  end

  def then_i_see_links_to_the_referral_form_documents
    expect(page).to have_content "You can download and print the teacher misconduct form"
  end
end
