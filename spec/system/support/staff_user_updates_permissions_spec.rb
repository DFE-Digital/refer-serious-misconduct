# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff actions" do
  include CommonSteps

  scenario "Staff user with permissions updates another staff user's permissions", type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled

    when_i_login_as_a_case_worker_with_support_permissions_only
    then_i_see_the_staff_index
    and_i_see_the_permissions("view support")

    when_i_click_on_edit_permissions
    and_i_uncheck_view_support
    and_i_save_permissions
    then_i_see_the_error_message

    when_i_check_both_permissions
    and_i_save_permissions

    then_i_see_the_staff_index
    and_i_see_the_permissions_updated_message
    and_i_see_the_permissions("view support\nmanage referrals")
  end

  private

  def when_i_click_on_edit_permissions
    click_link "Change permissions"
  end

  def and_i_uncheck_view_support
    uncheck "view support", allow_label_click: true
  end

  def when_i_check_both_permissions
    check "view support", allow_label_click: true
    check "manage referrals", allow_label_click: true
  end

  def and_i_save_permissions
    click_button "Save permissions"
  end

  def then_i_see_the_error_message
    expect(page).to have_content("Select permissions")
  end

  def and_i_see_the_permissions_updated_message
    expect(page).to have_content("Staff permissions updated for test@example.org")
  end

  def and_i_see_the_permissions(permissions)
    expect(page).to have_current_path("/support/staff")

    within(all(".govuk-summary-list")[0]) do
      within(all(".govuk-summary-list__row")[2]) do
        expect(find(".govuk-summary-list__key").text).to eq("Permissions")
        expect(find(".govuk-summary-list__value p").text).to eq(permissions)
      end
    end
  end
end
