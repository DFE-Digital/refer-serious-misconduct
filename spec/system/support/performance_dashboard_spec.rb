require "rails_helper"

RSpec.feature "Performance dashboard" do
  include CommonSteps

  scenario "List validation errors", type: :system do
    given_the_service_is_open
    when_i_login_as_a_case_worker_with_support_permissions_only

    when_i_visit_the_performance_dashboard
    then_i_see_the_performance_dashboard
  end

  def when_i_visit_the_performance_dashboard
    visit("/support/performance")
  end

  def then_i_see_the_performance_dashboard
    expect(page).to have_text("Performance dashboard")
    expect(page).to have_text("Eligibility checks by day")
  end
end
