# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Eligibility screener", type: :system do
  include CommonSteps

  scenario "User completes eligibility screener as member of public" do
    given_the_service_is_open
    and_the_eligibility_screener_feature_is_active
    and_the_referral_form_feature_is_active
    and_i_am_signed_in
    when_i_visit_the_service
    then_i_see_the_employer_or_public_question

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_referring_as_public
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
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_no_jurisdiction_page
    when_i_go_back
    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_complaint_or_referral_question

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_make_a_complaint
    when_i_press_continue
    then_i_see_the_make_a_complaint_page
    when_i_go_back
    when_i_choose_refer_serious_misconduct
    when_i_press_continue
    then_i_see_the_you_should_know_page

    when_i_press_continue
    then_i_have_started_a_member_of_public_referral
    and_event_tracking_is_working
  end

  private

  def then_i_see_a_validation_error
    expect(page).to have_content("There’s a problem")
  end

  def then_i_see_the_employer_or_public_question
    expect(page).to have_current_path("/referral-type")
    expect(page).to have_title("Are you making a referral as an employer or member of the public?")
    expect(page).to have_content(
      "Are you making a referral as an employer or member of the public?"
    )
  end

  def then_i_see_the_is_a_teacher_page
    expect(page).to have_current_path("/is-a-teacher")
    expect(page).to have_title(
      "Who the allegation is about - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Who the allegation is about")
  end

  def then_i_see_the_no_jurisdiction_page
    expect(page).to have_current_path("/no-jurisdiction")
    expect(page).to have_title(
      [
        "You cannot refer a teacher who was not employed in England",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
    expect(page).to have_content("You cannot refer a teacher who was not employed in England")
  end

  def then_i_see_the_no_jurisdiction_unsupervised_page
    expect(page).to have_current_path("/no-jurisdiction-unsupervised")
    expect(page).to have_title(
      [
        "You cannot use this service to refer someone who is not a teacher",
        "Refer serious misconduct by a teacher in England"
      ].join(" - ")
    )
    expect(page).to have_content(
      "You cannot use this service to refer someone who is not a teacher"
    )
  end

  def then_i_see_the_make_a_complaint_page
    expect(page).to have_current_path("/make-a-complaint")
    expect(page).to have_title(
      "Make a complaint - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Make a complaint")
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

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
    expect(page).to have_title(
      "What completing this referral means for you - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What completing this referral means for you")
  end

  def then_i_see_the_complaint_or_referral_question
    expect(page).to have_current_path("/complaint-or-referral")
    expect(page).to have_title(
      "Check if you should make a complaint or refer the teacher for serious misconduct - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Check if you should make a complaint or refer the teacher for serious misconduct"
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

  def when_i_choose_referring_as_public
    choose "I’m referring as a member of the public", visible: false
  end

  def when_i_choose_make_a_complaint
    choose "Make a complaint", visible: false
  end

  def when_i_choose_refer_serious_misconduct
    choose "Refer serious misconduct", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_go_back
    click_link "Back"
  end

  def when_i_press_continue
    click_on "Continue"
  end

  def when_i_visit_the_service
    visit root_path
  end

  def then_i_have_started_a_member_of_public_referral
    referral = @user.latest_referral

    expect(page).to have_current_path edit_public_referral_path(referral)
    expect(referral).to be_from_member_of_public
  end
end
