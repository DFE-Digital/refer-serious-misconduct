require "rails_helper"

RSpec.feature "Employer Referral: About You", type: :system do
  scenario "User provides their details" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_am_on_the_referral_summary_page
    when_i_click_on_your_details
    then_i_am_on_the_your_details_page

    when_i_click_save_and_continue
    then_i_see_the_name_error_message

    when_i_enter_my_name
    and_i_click_save_and_continue
    then_i_see_the_job_title_page

    when_i_click_save_and_continue
    then_i_see_the_job_title_error_message

    when_i_enter_my_job_title
    and_i_click_save_and_continue
    then_i_see_the_what_is_your_telephone_number_page

    when_i_click_save_and_continue
    then_i_see_the_telephone_error_message

    when_i_enter_my_telephone_number
    when_i_click_save_and_continue
    then_i_see_the_referrer_check_your_answers_page
    and_i_see_my_answers_on_the_referrer_check_your_answers_page

    when_i_click_on_change_name
    then_i_am_on_the_your_details_page
    and_i_see_my_name_in_the_form_field

    when_i_click_back
    and_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_am_on_the_referral_summary_page
    and_i_see_your_details_flagged_as_incomplete

    when_i_click_on_your_details
    then_i_see_the_name_prefilled

    when_i_click_save_and_continue
    then_i_see_the_job_title_prefilled

    when_i_click_save_and_continue
    then_i_see_the_phone_number_prefilled

    when_i_click_save_and_continue
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_your_details_flagged_as_complete
  end

  private

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_i_am_on_the_referral_summary_page
    visit edit_referral_path(@referral)
  end

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: false
  end

  def and_i_have_an_existing_referral
    @referral = Referral.create!
  end

  def and_i_see_my_name_in_the_form_field
    expect(page).to have_field("What is your name?", with: "Test Name")
  end

  def and_i_see_my_answers_on_the_referrer_check_your_answers_page
    expect(page).to have_content("Your name\tTest Name")
    expect(page).to have_content("Telephone number\t01234567890")
  end

  def and_i_see_your_details_flagged_as_incomplete
    your_details_row = find(".app-task-list__item", text: "Your details")
    expect(your_details_row).to have_content("INCOMPLETE")
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def then_i_am_on_the_referral_summary_page
    expect(page).to have_current_path(edit_referral_path(@referral))
  end

  def then_i_am_on_the_your_details_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/referrer-name/edit"
    )
    expect(page).to have_title(
      "What is your name? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your name?")
  end

  def then_i_see_the_job_title_page
    expect(page).to have_current_path(
      "/referrals/#{Referral.last.id}/referrer-job-title/edit"
    )
    expect(page).to have_title(
      "What is your job title? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your job title?")
  end

  def then_i_see_the_job_title_error_message
    expect(page).to have_content("Enter your job title")
  end

  def then_i_see_the_job_title_prefilled
    expect(page).to have_field("What is your job title?", with: "Teacher")
  end

  def then_i_see_the_phone_number_prefilled
    expect(page).to have_field(
      "What is your telephone number?",
      with: "01234567890"
    )
  end

  def then_i_see_the_name_error_message
    expect(page).to have_content("Enter your name")
  end

  def then_i_see_the_name_prefilled
    expect(page).to have_field("What is your name?", with: "Test Name")
  end

  def then_i_see_the_referrer_check_your_answers_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/referrer")
    expect(page).to have_title(
      "Your details - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your details")
  end

  def then_i_see_the_telephone_error_message
    expect(page).to have_content("Enter your telephone number")
  end

  def then_i_see_the_what_is_your_telephone_number_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/referrer-phone/edit"
    )
    expect(page).to have_title(
      "What is your telephone number? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your telephone number?")
  end

  def then_i_see_your_details_flagged_as_complete
    expect(page).to have_content("Your details\nCOMPLETE")
  end

  def when_i_click_back
    click_on "Back"
  end

  def when_i_click_on_change_name
    click_on "Change name"
  end

  def when_i_click_on_your_details
    click_link "Your details"
  end

  def when_i_click_save_and_continue
    click_button "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def when_i_enter_my_job_title
    fill_in "What is your job title?", with: "Teacher"
  end

  def when_i_enter_my_name
    fill_in "What is your name?", with: "Test Name"
  end

  def when_i_enter_my_telephone_number
    fill_in "What is your telephone number?", with: "01234567890"
  end
end
