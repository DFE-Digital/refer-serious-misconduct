# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Staff invitations" do
  include CommonSteps

  scenario "Staff user with basic auth is not authorized to send account invitation",
           type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_staff_http_basic_is_active

    when_i_am_authorized_with_basic_auth_as_a_case_worker
    when_i_visit_the_staff_invitation_page

    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def when_i_visit_the_staff_invitation_page
    visit support_interface_staff_index_path
  end
end
