# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Feedback", type: :system do
  include CommonSteps

  scenario "User gives feedback" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    when_i_visit_the_service
    and_i_click_on_feedback

    then_i_see_the_feedback_form
    when_i_press_send_feedback
    then_i_see_validation_errors
    when_i_choose_satisfied
    then_i_see_validation_errors
    when_i_fill_in_how_we_can_improve
    then_i_see_validation_errors
    when_i_choose_yes
    then_i_see_validation_errors
    when_i_enter_an_email
    when_i_press_send_feedback
    then_i_see_the_feedback_sent_page
  end

  private

  def and_i_click_on_feedback
    click_on "feedback"
  end

  def then_i_see_the_feedback_form
    expect(page).to have_current_path("/feedback")
    expect(page).to have_title("Give feedback about referring serious misconduct by a teacher")
    expect(page).to have_content("How satisfied are you with the service?")
  end

  def when_i_press_send_feedback
    click_on "Send feedback"
  end

  def then_i_see_validation_errors
    expect(page).to have_content("There’s a problem")
  end

  def when_i_choose_satisfied
    find("label", text: "Satisfied").click
  end

  def when_i_fill_in_how_we_can_improve
    fill_in "How can we improve the service?", with: "Make it better"
  end

  def when_i_choose_yes
    find("label", text: "Yes").click
  end

  def when_i_enter_an_email
    fill_in "Email address", with: "my_email@example.com"
  end

  def then_i_see_the_feedback_sent_page
    expect(page).to have_current_path("/feedback/confirmation")
    expect(page).to have_title("Feedback sent")
    expect(page).to have_content("Next steps")
  end
end
