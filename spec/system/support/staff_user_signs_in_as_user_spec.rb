# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Test users" do
  include CommonSteps

  scenario "Staff user signs in as user" do
    given_the_service_is_open
    and_the_employer_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_the_user_accounts_feature_is_active
    and_staff_http_basic_is_active
    when_i_am_authorized_as_a_support_user

    and_i_visit_the_test_users_section
    and_i_create_a_new_user
    then_the_user_is_created

    when_i_click_sign_in_for_that_user
    then_i_am_signed_in_as_that_user
  end

  private

  def and_staff_http_basic_is_active
    FeatureFlags::FeatureFlag.activate(:staff_http_basic_auth)
  end

  def when_i_am_authorized_as_a_support_user
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end

  def and_i_visit_the_test_users_section
    visit support_interface_root_path
    click_link "Test Users"
  end

  def and_i_create_a_new_user
    click_button "Create new user"
  end

  def then_the_user_is_created
    @user = User.last
    expect(page).to have_content "User #{@user.email} created"
  end

  def when_i_click_sign_in_for_that_user
    within(".govuk-table__row", text: @user.email) { click_button "Sign in" }
  end

  def then_i_am_signed_in_as_that_user
    expect(page).to have_content "Sign out"
  end
end
