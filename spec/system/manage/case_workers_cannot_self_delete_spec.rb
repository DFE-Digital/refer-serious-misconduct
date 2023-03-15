# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff actions" do
  include CommonSteps

  scenario "Staff users with permissions cannot self delete", type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled

    when_i_login_as_a_case_worker_with_support_permissions_only
    and_i_try_to_delete_my_user
    then_i_get_redirected_to_staff_index_page
    and_i_see_the_notification_message
    and_i_am_not_marked_as_deleted
  end

  private

  def and_i_try_to_delete_my_user
    @current_staff = Staff.last

    visit delete_support_interface_staff_path(@current_staff)
  end

  def then_i_get_redirected_to_staff_index_page
    expect(page).to have_current_path(support_interface_staff_index_path)
  end

  def and_i_see_the_notification_message
    expect(page).to have_content("You cannot delete your own user")
  end

  def and_i_am_not_marked_as_deleted
    expect(@current_staff.deleted_at).to be_nil
  end
end
