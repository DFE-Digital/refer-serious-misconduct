module CommonSteps
  include AuthenticationSteps
  include AuthorizationSteps
  include ActivateFeaturesSteps

  def when_i_visit_the_service
    visit root_path
  end

  def and_i_have_an_existing_referral
    @referral = create(:referral, user: @user)
  end
  alias_method :when_i_have_an_existing_referral, :and_i_have_an_existing_referral

  def and_i_am_a_member_of_the_public_with_an_existing_referral
    @referral =
      create(:referral, eligibility_check: create(:eligibility_check, :public), user: @user)
  end

  def and_referral_forms_exist
    create_list(:referral, 30, :submitted)
    create_list(:referral, 20)
  end

  def and_eligibility_checks_exist
    create_list(:eligibility_check, 20, :public)
    create_list(:eligibility_check, 20)
  end

  def and_there_are_staff_users
    create_list(:staff, 30, :random)
  end

  def and_i_visit_the_referral
    visit edit_referral_path(@referral)
  end
  alias_method :when_i_visit_the_referral, :and_i_visit_the_referral

  def and_i_visit_the_public_referral
    visit edit_public_referral_path(@referral)
  end
  alias_method :when_i_visit_the_public_referral, :and_i_visit_the_public_referral

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: false
  end
  alias_method :when_i_choose_complete, :and_i_choose_complete

  def and_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: false
  end
  alias_method :when_i_choose_no_come_back_later, :and_i_choose_no_come_back_later

  def and_the_allegation_section_is_incomplete
    within(all(".app-task-list__section")[2]) do
      within(all(".app-task-list__item")[0]) do
        expect(find(".app-task-list__task-name a").text).to eq("Details of the allegation")
        expect(find(".app-task-list__tag").text).to eq("INCOMPLETE")
      end
    end
  end

  def then_event_tracking_is_working
    expect(:web_request).to have_been_enqueued_as_analytics_events
  end
  alias_method :and_event_tracking_is_working, :then_event_tracking_is_working

  def then_i_see_the_referral_summary
    expect(page).to have_current_path(edit_referral_path(@referral))
    expect(page).to have_title("Refer serious misconduct by a teacher in England")
    expect(page).to have_content("Your referral")
  end

  def then_i_see_the_public_referral_summary
    expect(page).to have_current_path(edit_public_referral_path(@referral))
    expect(page).to have_title("Refer serious misconduct by a teacher in England")
  end

  def then_i_see_check_answers_form_validation_errors
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def then_i_see_pagination
    within(".govuk-pagination") { expect(page).to have_content "Next" }
  end
  alias_method :and_i_see_pagination, :then_i_see_pagination

  def and_i_see_personal_details_flagged_as_incomplete
    within(".app-task-list__item", text: "Personal details") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to have_content("INCOMPLETE")
    end
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def when_i_click_continue
    click_on "Continue"
  end
  alias_method :and_i_click_continue, :when_i_click_continue

  def when_i_click_on_change_name
    click_on "Change your name"
  end
  alias_method :and_i_click_on_change_name, :when_i_click_on_change_name

  def when_i_click_on_change_phone_number
    click_on "Change your phone number"
  end
  alias_method :and_i_click_on_change_phone_number, :when_i_click_on_change_phone_number

  def when_i_click_on_your_details
    click_link "Your details"
  end
  alias_method :and_i_click_on_your_details, :when_i_click_on_your_details

  def when_i_click_on_personal_details
    click_link "Personal details"
  end
  alias_method :and_i_click_on_personal_details, :when_i_click_on_personal_details

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back

  def when_i_enter_my_name
    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
  end

  def when_i_enter_my_phone_number
    fill_in "Your phone number", with: "01234567890"
  end

  def then_i_am_on_the_your_name_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/referrer/name/edit",
      ignore_query: true
    )
    expect(page).to have_title(
      "Your name - Your details - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your name")
  end

  def then_i_see_the_what_is_your_phone_number_page
    expect(page).to have_current_path("/public-referrals/#{@referral.id}/referrer/phone/edit")
    expect(page).to have_title(
      "Your phone number - Your details - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your phone number")
  end

  def then_i_see_the_referrer_check_your_answers_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/referrer/check-answers/edit"
    )
    expect(page).to have_title("Your details - Refer serious misconduct by a teacher in England")
    expect(page).to have_content("Your details")
    expect(page).to have_content("Check and confirm your answers")
  end
end
