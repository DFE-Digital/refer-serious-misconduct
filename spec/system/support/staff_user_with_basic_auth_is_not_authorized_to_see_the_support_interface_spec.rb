# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Support" do
  include CommonSteps

  scenario "a staff user with basic auth is not authorized to see the support interface",
           type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    and_staff_http_basic_is_active
    when_i_am_authorized_with_basic_auth_as_a_case_worker
    and_i_visit_the_support_page
    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def and_i_visit_the_support_page
    visit support_interface_root_path
  end
end
