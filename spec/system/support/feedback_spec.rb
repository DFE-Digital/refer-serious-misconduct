require "rails_helper"

RSpec.feature "Feedback back office" do
  include CommonSteps

  let(:feedback) { create(:feedback) }

  scenario "Manage user" do
    given_the_service_is_open
    when_i_login_as_staff_with_permissions(manage_referrals: true)
    then_i_see_manage_referrals_page
    and_i_do_not_see_feedback_navigation

    when_i_visit_the_feedback_page
    then_i_see_403
  end

  scenario "Support user" do
    given_the_service_is_open
    and_feedback_exists
    when_i_login_as_staff_with_permissions(view_support: true)
    then_i_see_the_staff_index
    and_i_see_feedback_navigation

    when_i_click_feedback_navigation
    then_i_see_feedback
  end

  def and_i_see_feedback_navigation
    expect(page).to have_content("Feedback")
  end

  def and_i_do_not_see_feedback_navigation
    expect(page).not_to have_content("Feedback")
  end

  def when_i_click_feedback_navigation
    click_link "Feedback"
  end

  def and_feedback_exists
    feedback
  end

  def then_i_see_feedback
    expect(page).to have_content(feedback.email)
  end

  def when_i_visit_the_feedback_page
    visit("/support/feedback")
  end

  def then_i_see_403
    expect(page).to have_current_path("/403")
    expect(page).to have_content("You do not have permission to view this page")
  end
end
