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
    then_i_see_the_complained_to_school_page

    when_i_press_continue
    then_i_see_a_validation_error

    ## Handles the 3 branching options for the complained to school page
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_make_a_complaint_page
    when_i_go_back
    then_i_see_the_complained_to_school_page
    when_i_choose_awaiting_outcome
    when_i_press_continue
    then_i_see_the_awaiting_outcome_page
    when_i_go_back
    then_i_see_the_complained_to_school_page
    when_i_choose_received_outcome
    when_i_press_continue

    then_i_see_the_allegation_page
    when_i_press_continue
    then_i_see_a_validation_error
    when_i_select("None of these")
    when_i_press_continue
    then_i_see_the_consider_if_you_should_make_a_referral_page
    when_i_go_back
    then_i_see_the_allegation_page
    when_i_select("Sexual misconduct")
    when_i_press_continue

    then_i_see_the_is_a_teacher_page
    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_no
    when_i_press_continue
    then_i_see_the_no_jurisdiction_unsupervised_page

    ## Tests that the back link works for the no jurisdiction unsupervised teaching page
    when_i_go_back
    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_teaching_in_england_page

    when_i_press_continue
    then_i_see_a_validation_error
    when_i_choose_not_sure
    when_i_choose_no
    when_i_press_continue

    ## Tests that the back link works for the no jurisdiction page
    then_i_see_the_no_jurisdiction_page
    when_i_go_back
    when_i_choose_yes
    when_i_press_continue
    then_i_see_the_you_should_know_page

    when_i_press_i_understand
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
    expect(page).to have_current_path("/public-is-a-teacher")
    expect(page).to have_title(
      "Who the allegation is about - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Who the allegation is about")
  end

  def then_i_see_the_allegation_page
    expect(page).to have_current_path("/what-allegation-involves")
    expect(page).to have_title(
                      "Does your allegation involve any of the following?"
                    )
    expect(page).to have_content("Select all that apply")
  end

  def then_i_click_the_refer_misconduct_link
    click_link "I still want to refer serious misconduct by a teacher"
  end

  def then_i_see_the_no_jurisdiction_page
    expect(page).to have_current_path("/no-jurisdiction")
    expect(page).to have_title(
      "You cannot refer a teacher who was not employed in England - " \
        "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("You cannot refer a teacher who was not employed in England")
  end

  def then_i_see_the_no_jurisdiction_unsupervised_page
    expect(page).to have_current_path("/no-jurisdiction-unsupervised")
    expect(page).to have_title(
      "You cannot use this service to refer someone who is not a teacher - " \
        "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "You cannot use this service to refer someone who is not a teacher"
    )
  end

  def then_i_see_the_make_a_complaint_page
    expect(page).to have_current_path("/make-complaint")
    expect(page).to have_title(
      "Make a complaint - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Make a complaint")
  end

  def then_i_see_the_teaching_in_england_page
    expect(page).to have_current_path("/public-teaching-in-england")
    expect(page).to have_title(
      "Were they employed in England at the time the alleged misconduct took place? - " \
        "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Were they employed in England at the time the alleged misconduct took place?"
    )
  end

  def then_i_see_the_consider_if_you_should_make_a_referral_page
    expect(page).to have_current_path("/consider-if-you-should-make-referral")
    expect(page).to have_title(
                      "Consider if you should make a referral"
                    )
    expect(page).to have_content(
                      "If you refer the teacher for something which is not serious misconduct, it will"
                    )
  end

  def then_i_see_the_you_should_know_page
    expect(page).to have_current_path("/you-should-know")
    expect(page).to have_title(
      "What will happen after you refer the teacher for serious misconduct - " \
        "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "What will happen after you refer the teacher for serious misconduct"
    )
  end

  def then_i_see_the_complaint_or_referral_question
    expect(page).to have_current_path("/complaint-or-referral")
    expect(page).to have_title(
      "Check if you should make a complaint or refer the teacher for serious misconduct - " \
        "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Check if you should make a complaint or refer the teacher for serious misconduct"
    )
  end

  def then_i_see_the_complained_to_school_page
    expect(page).to have_current_path("/complained-about-teacher")
    expect(page).to have_title(
                      "Have you complained to the school about the teacher?"
                    )
  end

  def then_i_see_the_awaiting_outcome_page
    expect(page).to have_current_path("/wait-for-outcome")
    expect(page).to have_title(
                      "Wait for an outcome before making a referral"
                    )
  end

  def when_i_select(option)
    check option, allow_label_click: true
  end

  def when_i_choose_no
    find("label", text: "No").click
  end

  def when_i_choose_not_sure
    find("label", text: "I’m not sure").click
  end

  def when_i_choose_referring_as_public
    find("label", text: "I’m referring as a member of the public").click
  end

  def when_i_choose_make_a_complaint
    find("label", text: "Make a complaint").click
  end

  def when_i_choose_refer_serious_misconduct
    find("label", text: "Refer serious misconduct").click
  end

  def when_i_choose_yes
    find("label", text: "Yes").click
  end

  def when_i_choose_awaiting_outcome
    find("label", text: "Yes, and I'm waiting for an outcome").click
  end

  def when_i_choose_received_outcome
    find("label", text: "Yes, and I received an outcome").click
  end

  def when_i_go_back
    click_link "Back"
  end

  def when_i_press_continue
    click_on "Continue"
  end

  def when_i_press_i_understand
    click_on "I understand and want to continue"
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
