require "rails_helper"

RSpec.feature "View eligibility checks" do
  include CommonSteps

  scenario "visiting the eligibility checks page", type: :system do
    given_the_service_is_open

    when_i_login_as_a_case_worker_with_support_permissions_only
    and_i_visit_the_eligibility_checks_page
    then_i_see_the_eligibility_checks

    when_i_click_the_download_csv_link
    there_are_no_errors
  end

  private

  def and_i_visit_the_eligibility_checks_page
    visit "/support/eligibility-checks"
  end

  def then_i_see_the_eligibility_checks
    expect(page).to have_content "Eligibility checks"
  end

  def when_i_click_the_download_csv_link
    click_link "Download CSV"
  end

  alias_method :there_are_no_errors, :then_i_see_the_eligibility_checks
end
