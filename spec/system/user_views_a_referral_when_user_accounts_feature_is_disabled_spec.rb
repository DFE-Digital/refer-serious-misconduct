# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User accounts disabled, user views a referral summary",
              type: :system do
  include CommonSteps

  scenario "User views referral summary" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_the_eligbility_screener_feature_is_active
    and_the_user_accounts_feature_is_inactive
    and_there_is_an_existing_referral
    when_i_visit_the_referral
    then_i_am_redirected_to_the_start_page
  end

  private

  def and_there_is_an_existing_referral
    @referral = create(:referral, user: create(:user))
  end

  def and_the_user_accounts_feature_is_inactive
    FeatureFlags::FeatureFlag.deactivate(:user_accounts)
  end

  def then_i_am_redirected_to_the_start_page
    expect(current_path).to eq(start_path)
  end
end
