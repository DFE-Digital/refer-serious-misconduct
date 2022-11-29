# frozen_string_literal: true
require "rails_helper"

RSpec.feature "User views an existing referral summary", type: :system do
  scenario "Views referral summary sections" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    and_i_have_an_existing_referral
    when_i_visit_the_referral_summary
    then_i_see_the_referral_as_sections
  end

  private

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_i_have_an_existing_referral
    @referral = create(:referral, user: @user)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_see_the_referral_as_sections
    expect(page).to have_content("Your allegation of serious misconduct")

    within(all(".app-task-list__section").first) do
      expect(page).to have_content("1. About you")
    end

    within(all(".app-task-list__section")[1]) do
      expect(page).to have_content("2. About the person you are referring")
    end

    within(all(".app-task-list__section").last) do
      expect(page).to have_content("3. The allegation")
    end
  end

  def when_i_visit_the_referral_summary
    visit edit_referral_path(@referral)
  end
end
