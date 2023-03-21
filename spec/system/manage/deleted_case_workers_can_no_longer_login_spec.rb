# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff actions" do
  include CommonSteps

  scenario "Deleted staff users can no longer login", type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_i_have_been_soft_deleted

    when_i_login
    then_i_get_redirected_to_manage_sign_in_page
    and_i_see_the_notification_message
  end

  private

  def and_i_have_been_soft_deleted
    @user = create(:staff, :confirmed, :can_view_support, :deleted)
  end

  def when_i_login
    visit manage_sign_in_path

    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end

  def and_i_see_the_notification_message
    expect(page).to have_content("Your account is not activated yet")
  end

  def then_i_get_redirected_to_manage_sign_in_page
    expect(page).to have_current_path(manage_sign_in_path)
  end
end
