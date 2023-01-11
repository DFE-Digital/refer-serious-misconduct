# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Question order", type: :system do
  include CommonSteps

  scenario "is enforced correctly" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active
    and_i_am_signed_in
    when_i_visit_the_service
    then_i_see_the_start_page

    when_i_visit_the_unsupervised_teaching_page
    then_i_see_the_start_page

    when_i_visit_the_teaching_in_england_page
    then_i_see_the_start_page

    when_i_visit_the_serious_misconduct_page
    then_i_see_the_start_page

    when_i_visit_the_complete_page
    then_i_see_the_start_page

    when_i_press_start
    when_i_choose_employer
    when_i_press_continue
    then_i_see_the_is_a_teacher_page

    when_i_visit_unsupervised_teaching_page
    then_i_see_the_is_a_teacher_page

    when_i_visit_the_serious_misconduct_page
    then_i_see_the_is_a_teacher_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_teaching_in_england_page

    when_i_visit_the_serious_misconduct_page
    then_i_see_the_teaching_in_england_page
  end

  private

  def then_i_see_the_is_a_teacher_page
    expect(page).to have_current_path("/is-a-teacher")
  end

  def then_i_see_the_employer_or_public_page
    expect(page).to have_current_path("/referral-type")
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/start")
  end

  def then_i_see_the_teaching_in_england_page
    expect(page).to have_current_path("/teaching-in-england")
  end

  def then_i_see_the_unsupervised_teaching_page
    expect(page).to have_current_path("/unsupervised-teaching")
  end

  def when_i_choose_employer
    choose "I’m referring as an employer", visible: false
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

  def when_i_visit_the_complete_page
    visit complete_path
  end

  def when_i_visit_the_serious_misconduct_page
    visit serious_misconduct_path
  end

  def when_i_visit_the_service
    visit root_path
  end

  def when_i_visit_unsupervised_teaching_page
    visit unsupervised_teaching_path
  end

  def when_i_visit_you_should_know_page
    visit you_should_know_path
  end

  def when_i_visit_the_teaching_in_england_page
    visit teaching_in_england_path
  end

  def when_i_visit_the_unsupervised_teaching_page
    visit unsupervised_teaching_path
  end
end
