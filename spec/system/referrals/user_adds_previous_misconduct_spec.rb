require "rails_helper"

RSpec.feature "Employer Referral: Previous Misconduct", type: :system do
  scenario "User provides details of previous misconduct" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_am_on_the_referral_summary_page
    when_i_click_on_previous_misconduct
    then_i_see_the_previous_misconduct_reported_page

    when_i_click_save_and_continue
    then_i_see_the_missing_reported_error

    when_i_choose_no
    and_i_click_save_and_continue
    then_i_see_the_previous_misconduct_page
    and_i_see_no_previous_misconduct_reported

    when_i_click_change_previous_misconduct_reported
    then_i_see_the_previous_misconduct_reported_page
    and_i_see_no_previous_misconduct_is_prefilled

    when_i_choose_yes
    and_i_click_save_and_continue
    then_i_see_the_previous_misconduct_page

    when_i_click_save_and_continue
    then_i_am_asked_to_make_a_choice

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_am_on_the_referral_summary_page
    and_i_see_previous_misconduct_flagged_as_incomplete

    when_i_go_back
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_am_on_the_referral_summary_page
    and_i_see_previous_misconduct_flagged_as_complete
  end

  private

  def and_i_am_on_the_referral_summary_page
    visit edit_referral_path(@referral)
  end

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_i_have_an_existing_referral
    @referral = create(:referral, user: @user)
  end

  def and_i_see_no_previous_misconduct_is_prefilled
    expect(page).to have_checked_field("No", visible: false)
  end

  def and_i_see_no_previous_misconduct_reported
    expect(page).to have_content("No")
  end

  def and_i_see_previous_misconduct_flagged_as_complete
    within(".app-task-list__item", text: "Previous allegations") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to match(/^COMPLETE/)
    end
  end

  def and_i_see_previous_misconduct_flagged_as_incomplete
    within(".app-task-list__item", text: "Previous allegations") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to match("INCOMPLETE")
    end
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_am_asked_to_make_a_choice
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def then_i_am_on_the_referral_summary_page
    expect(page).to have_current_path(edit_referral_path(@referral))
  end

  def then_i_see_the_previous_misconduct_reported_page
    expect(page).to have_current_path(
      edit_referral_previous_misconduct_reported_path(@referral)
    )
    expect(page).to have_title(
      "Has there been any previous misconduct, disciplinary action or complaints? - Refer " \
        "serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Has there been any previous misconduct, disciplinary action or complaints?"
    )
  end

  def then_i_see_the_missing_reported_error
    expect(page).to have_content(
      "Let us know if there has been any previous misconduct, disciplinary action or complaints"
    )
  end

  def then_i_see_the_previous_misconduct_page
    expect(page).to have_content("Check and confirm your answers")
    expect(page).to have_content("Previous allegations")
  end

  def when_i_choose_no
    choose "No", visible: false
  end

  def when_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: false
  end

  def when_i_choose_yes
    choose "Yes", visible: false
  end

  def when_i_click_change_previous_misconduct_reported
    click_on "Change reported"
  end

  def when_i_click_on_previous_misconduct
    click_on "Previous allegations"
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def when_i_go_back
    page.go_back
  end
end
