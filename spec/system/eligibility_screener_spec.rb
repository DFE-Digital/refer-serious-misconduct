# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Eligibility screener", type: :system do
  it "happy path" do
    given_the_service_is_open
    when_i_visit_the_service
    then_i_see_the_start_page

    when_i_press_start
    then_i_see_the_employer_or_public_question

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_reporting_as_an_employer
    when_i_press_continue
    then_i_see_the_serious_misconduct_question

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_not_sure
    then_i_see_the_not_sure_hint
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_not_serious_misconduct_page
    when_i_go_back
    when_i_choose_yes
    when_i_press_continue

    then_i_see_the_you_should_know_page
    when_i_press_continue

    then_i_see_the_completion_page
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_see_a_validation_error
    expect(page).to have_content("There is a problem")
  end

  def then_i_see_the_completion_page
    expect(page).to have_current_path("/complete")
    expect(page).to have_title(
      "You need to complete a referral form - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content("You need to complete a referral form")
  end

  def then_i_see_the_employer_or_public_question
    expect(page).to have_current_path("/who")
    expect(page).to have_title(
      "Are you reporting as an employer or member of the public? - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content(
      "Are you reporting as an employer or member of the public?"
    )
  end

  def then_i_see_the_not_sure_hint
    expect(page).to have_content(
      "If you’re not sure, please continue to report your allegation and the Teaching Regulation Agency will assess it."
    )
  end

  def then_i_see_the_not_serious_misconduct_page
    expect(page).to have_current_path("/not-serious-misconduct")
    expect(page).to have_title(
      "You need to report this misconduct somewhere else - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content(
      "You need to report this misconduct somewhere else"
    )
  end

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
    expect(page).to have_title(
      "What completing this report means for you - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content("What completing this report means for you")
  end

  def then_i_see_the_serious_misconduct_question
    expect(page).to have_current_path("/serious")
    expect(page).to have_title(
      "Does the allegation involve serious misconduct? - Refer serious misconduct by a teacher"
    )
    expect(page).to have_content(
      "Does the allegation involve serious misconduct?"
    )
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/start")
    expect(page).to have_title("Refer serious misconduct by a teacher")
    expect(page).to have_content("Refer serious misconduct by a teacher")
  end

  def when_i_choose_no
    choose "No", visible: false
  end

  def when_i_choose_not_sure
    choose "I’m not sure", visible: false
  end

  def when_i_choose_reporting_as_an_employer
    choose "I’m reporting as an employer", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_go_back
    page.go_back
  end

  def when_i_press_continue
    click_on "Continue"
  end

  def when_i_press_start
    click_link "Start now"
  end

  def when_i_visit_the_service
    visit root_path
  end
end
