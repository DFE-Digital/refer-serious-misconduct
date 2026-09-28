# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff invitations" do
  include CommonSteps

  scenario "Staff user with permissions re-invites a removed staff member", type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_a_staff_member_who_accepted_their_invitation

    when_i_login_as_a_case_worker_with_support_permissions_only
    then_i_see_the_staff_index
    and_i_see_the_returning_staff_member

    when_i_delete_the_returning_staff_member
    then_i_see_the_staff_index
    and_i_do_not_see_the_returning_staff_member

    when_i_click_on_invite
    and_i_fill_the_returning_staff_members_email_address
    and_i_select_manage_referrals
    and_i_send_invitation
    then_i_see_an_invitation_email
    and_i_see_the_returning_staff_member_invited

    when_i_am_not_authorized_as_a_staff_user
    and_i_visit_the_invitation_email
    and_i_set_a_new_password

    when_i_login_as_the_returning_staff_member
    then_i_see_manage_referrals_page
  end

  private

  def and_a_staff_member_who_accepted_their_invitation
    create(:staff, :confirmed, :can_view_support, email: "returning@example.com", invitation_accepted_at: 1.week.ago)
  end

  def and_i_see_the_returning_staff_member
    expect(page).to have_content("returning@example.com")
  end

  def when_i_delete_the_returning_staff_member
    click_link "Delete user"
    click_button "Delete user"
  end

  def and_i_do_not_see_the_returning_staff_member
    expect(page).to have_content("User deleted")
    expect(page).not_to have_content("returning@example.com")
  end

  def when_i_click_on_invite
    click_link "Invite"
  end

  def and_i_fill_the_returning_staff_members_email_address
    fill_in "Email address", with: "returning@example.com"
  end

  def and_i_select_manage_referrals
    check "Manage referrals", allow_label_click: true
  end

  def and_i_send_invitation
    click_button "Send invitation", visible: false
    expect(page).to have_content("An invitation email has been sent to returning@example.com")
    perform_enqueued_jobs
  end

  def then_i_see_an_invitation_email
    message = ActionMailer::Base.deliveries.last
    expect(message).not_to be_nil
    expect(message.subject).to eq("Invitation instructions")
    expect(message.to).to include("returning@example.com")
  end

  def and_i_see_the_returning_staff_member_invited
    visit support_interface_staff_index_path

    within(all(".govuk-summary-list")[0]) do
      expect(page).to have_content("Not accepted")
      expect(find(".govuk-summary-list__row", text: "Permissions")).to have_content("Manage referrals")
      expect(page).not_to have_content("View support")
    end
    expect(page).to have_link("Resend invitation")
  end

  def when_i_am_not_authorized_as_a_staff_user
    FeatureFlags::FeatureFlag.deactivate(:staff_http_basic_auth)

    Capybara.reset_sessions!
  end

  def and_i_visit_the_invitation_email
    message = ActionMailer::Base.deliveries.last
    uri = URI.parse(URI.extract(message.body.to_s).second)
    expect(uri.path).to eq("/invitation/accept")
    visit "#{uri.path}?#{uri.query}"
  end

  def and_i_set_a_new_password
    fill_in "staff-password-field", with: "Password123!"
    fill_in "staff-password-confirmation-field", with: "Password123!"
    click_button "Set my password", visible: false
  end

  def when_i_login_as_the_returning_staff_member
    Capybara.reset_sessions!

    visit manage_sign_in_path

    fill_in "staff-email-field", with: "returning@example.com"
    fill_in "staff-password-field", with: "Password123!"

    click_button "Sign in"
  end
end
