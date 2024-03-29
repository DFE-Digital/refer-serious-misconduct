# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Test users" do
  include CommonSteps

  scenario "Staff user with permissions can create test users", type: :system do
    given_the_service_is_open
    and_there_are_staff_users
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    when_i_login_as_a_case_worker_with_support_permissions_only
    then_i_see_the_staff_index
    and_i_see_pagination

    when_i_visit_staff_sign_in_page
    then_i_see_the_staff_index

    and_i_visit_the_test_users_section
    and_i_click_test_users_link
    and_i_create_a_new_user
    then_the_user_is_created

    when_i_click_sign_in_for_that_user
    then_i_am_signed_in_as_that_user
  end

  private

  def and_i_visit_the_test_users_section
    visit support_interface_root_path
  end

  def and_i_click_test_users_link
    click_link "Test Users"
  end

  def and_i_create_a_new_user
    click_button "Create new user"
  end

  def then_the_user_is_created
    @user = User.last
    expect(page).to have_content "User created for #{@user.email}"
  end

  def when_i_click_sign_in_for_that_user
    within(".govuk-table__row", text: @user.email) { click_button "Sign in" }
  end

  def then_i_am_signed_in_as_that_user
    expect(page).to have_content "Sign out"
  end
end
