# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Question order", type: :system do
  include CommonSteps

  scenario "is enforced correctly" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active

    when_i_visit_the_service
    then_i_see_the_do_you_have_an_account_page

    # Visiting pages before completion
    when_i_visit_the_unsupervised_teaching_page
    then_i_see_the_do_you_have_an_account_page

    when_i_visit_the_teaching_in_england_page
    then_i_see_the_do_you_have_an_account_page

    when_i_visit_the_serious_misconduct_page
    then_i_see_the_do_you_have_an_account_page

    when_i_visit_the_complete_page
    then_i_see_the_do_you_have_an_account_page

    # Partially completing screener
    when_i_visit_the_service
    then_i_see_the_do_you_have_an_account_page

    when_i_start_new_referral
    when_i_choose_employer
    when_i_press_continue
    then_i_see_the_is_a_teacher_page

    # Visiting pages out of order before completion
    when_i_visit_the_is_a_teacher_page
    then_i_see_the_is_a_teacher_page

    when_i_visit_the_unsupervised_teaching_page
    then_i_see_the_do_you_have_an_account_page

    # Resume and complete screener
    when_i_visit_the_is_a_teacher_page
    then_i_see_the_is_a_teacher_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_teaching_in_england_page

    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_serious_misconduct_page

    when_i_choose_refer_serious_misconduct
    when_i_press_continue
    then_i_see_the_you_should_know_page
  end

  private

  def then_i_see_the_is_a_teacher_page
    expect(page).to have_current_path("/is-a-teacher")
  end

  def then_i_see_the_employer_or_public_page
    expect(page).to have_current_path("/referral-type")
  end

  def then_i_see_the_teaching_in_england_page
    expect(page).to have_current_path("/teaching-in-england")
  end

  def then_i_see_the_unsupervised_teaching_page
    expect(page).to have_current_path("/unsupervised-teaching")
  end

  def then_i_see_the_do_you_have_an_account_page
    expect(page).to have_current_path("/users/registrations/exists")
  end

  def then_i_see_the_serious_misconduct_page
    expect(page).to have_current_path("/serious-misconduct")
  end

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
  end

  def when_i_start_new_referral
    choose "No", visible: false
    click_on "Continue"
  end

  def when_i_choose_employer
    choose "I’m referring as an employer", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_choose_refer_serious_misconduct
    choose "Refer serious misconduct", visible: false
  end

  def when_i_press_continue
    click_on "Continue"
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

  def when_i_visit_the_unsupervised_teaching_page
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

  def when_i_visit_the_is_a_teacher_page
    visit is_a_teacher_path
  end
end
