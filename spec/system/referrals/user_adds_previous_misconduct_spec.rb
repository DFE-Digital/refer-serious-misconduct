require "rails_helper"

RSpec.feature "Employer Referral: Previous Misconduct", type: :system do
  include CommonSteps

  scenario "User provides details of previous misconduct" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_existing_referral
    and_i_visit_the_referral
    when_i_click_on_previous_misconduct
    then_i_see_the_previous_misconduct_reported_page

    when_i_click_back
    then_i_see_the_referral_summary

    when_i_click_on_previous_misconduct
    and_i_click_save_and_continue
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
    then_i_see_the_previous_misconduct_details_page

    when_i_click_save_and_continue
    then_i_see_the_missing_details_error

    when_i_enter_details_as_text
    and_i_click_save_and_continue
    then_i_see_the_previous_misconduct_page
    and_i_see_the_details_are_displayed

    when_i_click_change_details
    then_i_see_the_details_prefilled

    when_i_upload_a_file
    and_i_click_save_and_continue
    then_i_see_the_previous_misconduct_page
    and_i_see_the_uploaded_file_name

    when_i_click_change_previous_misconduct_details_link
    then_i_can_see_the_previous_misconduct_file
    when_i_click_save_and_continue

    when_i_click_save_and_continue
    then_i_am_asked_to_make_a_choice

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_i_see_previous_misconduct_flagged_as_incomplete

    when_i_go_back
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_see_the_referral_summary
    and_i_see_previous_misconduct_flagged_as_complete
  end

  private

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: :all
  end

  def and_i_see_no_previous_misconduct_is_prefilled
    expect(page).to have_checked_field("No", visible: :all)
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

  def and_i_see_the_details_are_displayed
    expect(page).to have_content("Detailed account")
    expect(page).to have_content("Some details")
  end

  def and_i_see_the_uploaded_file_name
    expect(page).to have_content("Detailed account")
    expect(page).to have_content("upload.txt")
  end

  def then_i_am_asked_to_make_a_choice
    expect(page).to have_content("Select yes if you’ve completed this section")
  end

  def then_i_see_the_details_prefilled
    expect(page).to have_field(
      "Description of previous allegations",
      with: "Some details"
    )
  end

  def then_i_see_the_previous_misconduct_details_page
    expect(page).to have_current_path(
      edit_referral_previous_misconduct_detailed_account_path(@referral)
    )
  end

  def then_i_see_the_previous_misconduct_reported_page
    expect(page).to have_current_path(
      edit_referral_previous_misconduct_reported_path(@referral),
      ignore_query: true
    )
    expect(page).to have_title(
      "Has there been any previous misconduct, disciplinary action or complaints? - Refer " \
        "serious misconduct by a teacher in England"
    )
    expect(page).to have_content(
      "Has there been any previous misconduct, disciplinary action or complaints?"
    )
  end

  def then_i_see_the_missing_details_error
    expect(page).to have_content(
      "Select how you want to give details about previous allegations"
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
    choose "No", visible: :all
  end

  def when_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: :all
  end

  def when_i_choose_yes
    choose "Yes", visible: :all
  end

  def when_i_click_change_details
    click_on "Change detailed account"
  end

  def when_i_click_change_previous_misconduct_reported
    click_on "Change if there has been any previous misconduct"
  end

  def when_i_click_on_previous_misconduct
    click_on "Previous allegations"
  end

  def when_i_enter_details_as_text
    choose "Describe the previous allegations", visible: :all
    fill_in "Description of previous allegations", with: "Some details"
  end

  def when_i_go_back
    page.go_back
  end

  def when_i_upload_a_file
    choose "Upload file", visible: :all
    attach_file "Upload file", Rails.root.join("spec/support/upload.txt")
  end

  def when_i_click_change_previous_misconduct_details_link
    within(
      page.find(
        ".govuk-summary-list__row",
        text: "How do you want to give details about previous allegations?"
      )
    ) { click_link "Change" }
  end

  def then_i_can_see_the_previous_misconduct_file
    expect(page).to have_content("upload.txt (15 Bytes)")
  end
end
