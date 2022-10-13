# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Service wizard", type: :system do
  it "happy path" do
    given_the_service_is_open
    when_i_visit_the_service
    then_i_see_the_start_page

    when_i_press_start
    then_i_see_the_confirmation_page
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_current_path("/confirmation")
    expect(page).to have_title(
      "We have received your report of serious misconduct - Report serious misconduct by a teacher"
    )
    expect(page).to have_content(
      "We have received your report of serious misconduct"
    )
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/start")
    expect(page).to have_title("Report serious misconduct by a teacher")
    expect(page).to have_content("Report serious misconduct by a teacher")
  end

  def when_i_press_start
    click_link "Start now"
  end

  def when_i_visit_the_service
    visit root_path
  end
end
