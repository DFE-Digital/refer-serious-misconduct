# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff invitations" do
  include CommonSteps

  scenario "Staff user with permissions sends account invitation",
           type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled

    when_i_am_authorized_as_a_case_worker_with_support_permissions
    when_i_visit_the_staff_invitation_page
    then_i_see_the_staff_index
    when_i_click_on_invite
    then_i_see_the_staff_invitation_form
    when_i_fill_email_address
    and_i_send_invitation
    then_i_see_an_invitation_email
    then_i_see_the_invited_staff_user

    when_i_am_not_authorized_as_a_staff_user
    when_i_visit_the_invitation_email
    when_i_fill_password
    and_i_set_password
    then_i_am_unauthorized_and_redirected_to_root_path

    when_i_login_back_as_a_staff_user
    and_i_visit_the_staff_invitation_page
    then_i_see_the_staff_index
    and_i_see_the_accepted_staff_user
  end

  private

  def when_i_login_back_as_a_staff_user
    Capybara.reset_sessions!

    visit new_staff_session_path

    fill_in "staff-email-field", with: "test@example.org"
    fill_in "staff-password-field", with: "Example123!"

    click_button "Log in"
  end

  def when_i_visit_the_staff_invitation_page
    visit support_interface_staff_index_path
  end
  alias_method :and_i_visit_the_staff_invitation_page,
               :when_i_visit_the_staff_invitation_page

  def then_i_see_the_staff_index
    expect(page).to have_current_path("/support/staff")
    expect(page).to have_title("Staff")
  end

  def when_i_click_on_invite
    click_link "Invite"
  end

  def then_i_see_the_staff_invitation_form
    expect(page).to have_current_path("/staff/invitation/new")
    expect(page).to have_content("Send invitation")
    expect(page).to have_content("Email")
    expect(page).to have_content("Send an invitation")
  end

  def when_i_fill_email_address
    fill_in "staff-email-field", with: "test@example.com"
  end

  def and_i_send_invitation
    click_button "Send an invitation", visible: false
    perform_enqueued_jobs
  end

  def then_i_see_an_invitation_email
    message = ActionMailer::Base.deliveries.last
    expect(message).not_to be_nil
    expect(message.subject).to eq("Invitation instructions")
    expect(message.to).to include("test@example.com")
  end

  def then_i_see_the_invited_staff_user
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("NOT ACCEPTED")
  end

  def when_i_am_not_authorized_as_a_staff_user
    FeatureFlags::FeatureFlag.deactivate(:staff_http_basic_auth)

    Capybara.reset_sessions!
  end

  def when_i_visit_the_invitation_email
    message = ActionMailer::Base.deliveries.last
    uri = URI.parse(URI.extract(message.body.to_s).second)
    expect(uri.path).to eq("/staff/invitation/accept")
    expect(uri.query).to include("invitation_token=")
    visit "#{uri.path}?#{uri.query}"
  end

  def when_i_fill_password
    fill_in "staff-password-field", with: "Password123!"
    fill_in "staff-password-confirmation-field", with: "Password123!"
  end

  def and_i_set_password
    click_button "Set my password", visible: false
  end

  def then_i_am_taken_to_support_interface
    expect(page).to have_current_path("/support/eligibility_checks")
  end

  def and_i_see_the_accepted_staff_user
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("ACCEPTED")
  end
end
