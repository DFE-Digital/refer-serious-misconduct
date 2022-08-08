require "rails_helper"

RSpec.feature "Staff invitations", type: :system do
  scenario "Staff user sends account invitation" do
    given_the_service_is_open

    when_i_am_authorized_as_a_support_user
    when_i_visit_the_staff_invitation_page
    then_i_see_the_staff_invitation_form

    when_i_fill_email_address
    and_i_send_invitation
    then_i_see_an_invitation_email

    when_i_am_not_authorized_as_a_support_user
    when_i_visit_the_invitation_email
    when_i_fill_password
    and_i_set_password

    then_i_am_taken_to_support_interface
    and_a_new_account_is_created
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def when_i_am_authorized_as_a_support_user
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end

  def when_i_visit_the_staff_invitation_page
    visit new_staff_invitation_path
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
    expect(message).to_not be_nil
    expect(message.subject).to eq("Invitation instructions")
    expect(message.to).to include("test@example.com")
  end

  def when_i_am_not_authorized_as_a_support_user
    page.driver.open_new_window
  end

  def when_i_visit_the_invitation_email
    message = ActionMailer::Base.deliveries.last
    uri = URI.parse(URI.extract(message.body.to_s).second)
    expect(uri.path).to eq("/staff/invitation/accept")
    expect(uri.query).to include("invitation_token=")
    visit "#{uri.path}?#{uri.query}"
  end

  def when_i_fill_password
    fill_in "staff-password-field", with: "password"
    fill_in "staff-password-confirmation-field", with: "password"
  end

  def and_i_set_password
    click_button "Set my password", visible: false
  end

  def then_i_am_taken_to_support_interface
    expect(page).to have_current_path("/support/eligibility_checks")
  end

  def and_a_new_account_is_created
    staff_user = Staff.find_by(email: "test@example.com")
    expect(staff_user).to be_present
  end
end
