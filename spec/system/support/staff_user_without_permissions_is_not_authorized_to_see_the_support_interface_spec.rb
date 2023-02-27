# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Support" do
  include CommonSteps

  scenario "a staff user without permissions is not authorized to see the support interface",
           type: :system do
    given_the_service_is_open
    and_the_eligibility_screener_is_enabled
    when_i_login_as_a_case_worker_without_any_permissions_at_all
    then_i_am_unauthorized_and_redirected_to_root_path
  end

  private

  def and_i_visit_the_support_page
    visit support_interface_root_path
  end
end
