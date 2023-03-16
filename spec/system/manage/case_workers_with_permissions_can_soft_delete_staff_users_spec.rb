# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff actions" do
  include CommonSteps

  scenario "Staff users with permissions can soft delete other staff user", type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_there_are_staff_users

    when_i_login_as_a_case_worker_with_support_permissions_only
    then_i_see_the_staff_index

    when_i_choose_to_delete_other_staff_user
    then_i_see_the_warning_message
    and_i_click_continue
    then_i_no_longer_see_the_deleted_staff_user
    and_i_see_the_notification_message
    and_staff_user_is_marked_as_deleted
  end

  private

  def when_i_choose_to_delete_other_staff_user
    visit delete_support_interface_staff_path(@user)
  end

  def and_there_are_staff_users
    @user = create(:staff, :confirmed, :can_view_support, email: "another@test.com")
  end

  def then_i_see_the_warning_message
    expect(page).to have_content(@user.email)
    expect(page).to have_content("Confirm that you want to delete this user")
  end

  def then_i_no_longer_see_the_deleted_staff_user
    expect(page).not_to have_content(@user.email)
  end

  def and_i_click_continue
    click_on "Delete user"
  end

  def and_i_see_the_notification_message
    expect(page).to have_content("User deleted")
    expect(page).to have_current_path(support_interface_staff_index_path)
  end

  def and_staff_user_is_marked_as_deleted
    expect(@user.reload.deleted_at).not_to be_nil
  end
end
