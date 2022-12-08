# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Eligibility screener", type: :system do
  include CommonSteps

  scenario "happy path" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    and_i_am_signed_in
    when_i_visit_the_service
    then_i_see_the_start_page

    when_i_press_start
    then_i_see_the_employer_or_public_question

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_referring_as_public
    when_i_press_continue
    then_i_see_the_have_you_complained_page

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_you_should_complain_page
    when_i_press_continue_without_complaint
    then_i_see_the_is_a_teacher_page

    when_i_go_back
    when_i_go_back
    when_i_choose_yes_i_have_complained
    when_i_press_continue
    then_i_see_the_is_a_teacher_page

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_unsupervised_teaching_page

    when_i_go_back
    when_i_choose_not_sure
    when_i_press_continue
    then_i_see_the_unsupervised_teaching_page

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_not_sure
    then_i_see_the_not_sure_hint
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_no_jurisdiction_unsupervised_page
    when_i_go_back
    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_teaching_in_england_page

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_not_sure
    then_i_see_the_not_sure_hint
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_no_jurisdiction_page
    when_i_go_back
    when_i_choose_yes
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
    then_i_see_the_progress_is_saved_page
    when_i_press_continue
    then_i_have_started_a_member_of_public_referral
  end

  private

  def then_i_see_a_validation_error
    expect(page).to have_content("There is a problem")
  end

  def then_i_see_the_progress_is_saved_page
    expect(page).to have_content "Your progress is saved as you go"
  end

  def then_i_see_the_employer_or_public_question
    expect(page).to have_current_path("/who")
    expect(page).to have_title(
      "Are you making a referral as an employer or member of the public?"
    )
    expect(page).to have_content(
      "Are you making a referral as an employer or member of the public?"
    )
  end

  def then_i_see_the_have_you_complained_page
    expect(page).to have_current_path("/have-you-complained")
    expect(page).to have_title(
      [
        "Have you already made a complaint to the school, school governors or your local council?",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
    expect(page).to have_content(
      "Have you already made a complaint to the school, school governors or your local council?"
    )
  end

  def then_i_see_the_is_a_teacher_page
    expect(page).to have_current_path("/is-a-teacher")
    expect(page).to have_title(
      "Is the allegation about a teacher? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Is the allegation about a teacher?")
  end

  def then_i_see_the_no_jurisdiction_page
    expect(page).to have_current_path("/no-jurisdiction")
    expect(page).to have_title(
      "You need to make your referral somewhere else - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "You need to make your referral somewhere else"
    )
  end

  def then_i_see_the_no_jurisdiction_unsupervised_page
    expect(page).to have_current_path("/no-jurisdiction-unsupervised")
    expect(page).to have_title(
      "You need to report this misconduct somewhere else - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "You need to report this misconduct somewhere else"
    )
  end

  def then_i_see_the_not_sure_hint
    expect(page).to have_content(
      "If you’re not sure, you should continue to make a referral and TRA will assess it."
    )
  end

  def then_i_see_the_not_serious_misconduct_page
    expect(page).to have_current_path("/not-serious-misconduct")
    expect(page).to have_title(
      "You need to report this misconduct somewhere else - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "You need to report this misconduct somewhere else"
    )
  end

  def then_i_see_the_teaching_in_england_page
    expect(page).to have_current_path("/teaching-in-england")
    expect(page).to have_title(
      [
        "Were they employed in England at the time the alleged misconduct took place?",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
    expect(page).to have_content(
      "Were they employed in England at the time the alleged misconduct took place?"
    )
  end

  def then_i_see_the_you_should_complain_page
    expect(page).to have_current_path("/no-complaint")
    expect(page).to have_title(
      [
        "You should complain to the school, school governors or your local council first",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
    expect(page).to have_content(
      "You should complain to the school, school governors or your local council first"
    )
  end

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
    expect(page).to have_title(
      "What completing this referral means for you - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What completing this referral means for you")
  end

  def then_i_see_the_serious_misconduct_question
    expect(page).to have_current_path("/serious")
    expect(page).to have_title(
      "Does the allegation involve serious misconduct? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Does the allegation involve serious misconduct?"
    )
  end

  def then_i_see_the_start_page
    expect(page).to have_current_path("/start")
    expect(page).to have_title(
      "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Refer serious misconduct by a teacher in England"
    )
  end

  def then_i_see_the_unsupervised_teaching_page
    expect(page).to have_current_path("/unsupervised-teaching")
    expect(page).to have_title(
      [
        "You can refer someone who does unsupervised teaching work",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
  end

  def when_i_choose_no
    choose "No", visible: false
  end

  def when_i_choose_not_sure
    choose "I’m not sure", visible: false
  end

  def when_i_choose_referring_as_an_employer
    choose "I’m referring as an employer", visible: false
  end

  def when_i_choose_referring_as_public
    choose "I’m referring as a member of the public", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_choose_yes_i_have_complained
    choose "Yes, I’ve already made a complaint", visible: false
  end

  def when_i_go_back
    click_link "Back"
  end

  def when_i_press_continue
    click_on "Continue"
  end

  def when_i_press_continue_without_complaint
    click_on "Continue without an informal complaint"
  end

  def when_i_press_start
    click_link "Start now"
  end

  def when_i_visit_the_service
    visit root_path
  end

  def then_i_have_started_a_member_of_public_referral
    referral = User.last.latest_referral

    expect(page).to have_current_path edit_referral_path(referral)
    expect(referral).to be_from_member_of_public
  end
end
