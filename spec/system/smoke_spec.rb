# frozen_string_literal: true
require "spec_helper"
require "capybara/rspec"
require "capybara/cuprite"

Capybara.javascript_driver = :cuprite
Capybara.always_include_port = false

RSpec.describe "Smoke test", type: :system, js: true, smoke_test: true do
  it "works as expected" do
    given_i_am_authorized_as_a_support_user
    when_i_visit_the_service
    then_i_see_the_start_page

    when_i_press_start
    then_i_see_the_employer_or_public_question

    when_i_choose_reporting_as_an_employer
    when_i_press_continue
    then_i_see_the_is_a_teacher_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_teaching_in_england_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_serious_misconduct_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_you_should_know_page

    when_i_press_continue
    then_i_see_the_completion_page
  end

  it "/health/all returns 200" do
    page.visit("#{ENV["HOSTING_DOMAIN"]}/health/all")
    expect(page.status_code).to eq(200)
  end

  private

  def given_i_am_authorized_as_a_support_user
    page.driver.basic_authorize(
      ENV["SUPPORT_USERNAME"],
      ENV["SUPPORT_PASSWORD"]
    )
  end

  def then_i_see_the_completion_page
    expect(page).to have_current_path("/complete")
  end

  def then_i_see_the_employer_or_public_question
    expect(page).to have_current_path("/who")
  end

  def then_i_see_the_serious_misconduct_page
    expect(page).to have_current_path("/serious")
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/start")
  end

  def then_i_see_the_teaching_in_england_page
    expect(page).to have_current_path("/teaching-in-england")
  end

  def then_i_see_the_is_a_teacher_page
    expect(page).to have_current_path("/is-a-teacher")
  end

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
  end

  def when_i_choose_reporting_as_an_employer
    choose "I’m reporting as an employer", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_press_continue
    click_on "Continue"
  end

  def when_i_press_start
    click_link "Start now"
  end

  def when_i_visit_the_service
    page.visit("#{ENV["HOSTING_DOMAIN"]}/start")
  end
end
