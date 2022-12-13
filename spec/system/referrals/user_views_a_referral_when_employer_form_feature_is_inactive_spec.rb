# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Employer form inactive, user views a referral summary",
              type: :system do
  include CommonSteps

  scenario "User views referral summary" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_inactive
    and_there_is_an_existing_referral
    when_i_visit_the_referral
    then_i_am_redirected_to_the_start_page
  end

  private

  def and_there_is_an_existing_referral
    @referral = create(:referral, user: create(:user))
  end

  def and_the_referral_form_feature_is_inactive
    FeatureFlags::FeatureFlag.deactivate(:referral_form)
  end

  def then_i_am_redirected_to_the_start_page
    expect(page).to have_current_path(start_path, ignore_query: true)
  end
end
