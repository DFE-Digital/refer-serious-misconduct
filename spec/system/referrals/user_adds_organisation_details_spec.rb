require "rails_helper"

RSpec.feature "Employer Referral: Organisation", type: :system do
  scenario "User provides the organisation details" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    and_i_have_an_existing_referral
    and_i_am_on_the_referral_summary_page
    when_i_click_on_your_organisation

    then_i_am_on_the_organisation_name_page
    when_i_click_save_and_continue
    then_i_see_the_missing_name_error

    when_i_fill_in_the_organisation_name
    and_i_click_save_and_continue
    then_i_am_on_the_organisation_address_page

    when_i_click_save_and_continue
    then_i_see_the_missing_address_errors

    when_i_complete_the_address
    and_i_click_save_and_continue
    then_i_am_on_the_organisation_details_page

    when_i_click_change_organisation_name
    then_i_am_on_the_organisation_name_page
    and_i_see_the_name_prefilled

    when_i_click_save_and_continue
    then_i_am_on_the_organisation_details_page

    when_i_click_change_organisation_address
    then_i_am_on_the_organisation_address_page
    and_i_see_the_address_prefilled

    when_i_click_save_and_continue
    then_i_am_on_the_organisation_details_page

    when_i_click_save_and_continue
    then_i_am_asked_to_make_a_choice

    when_i_choose_no_come_back_later
    and_i_click_save_and_continue
    then_i_am_on_the_referral_summary_page
    and_i_see_your_organisation_flagged_as_incomplete

    when_i_go_back
    and_i_choose_complete
    and_i_click_save_and_continue
    then_i_am_on_the_referral_summary_page
    and_i_see_your_organisation_flagged_as_complete
  end

  private

  def and_i_choose_complete
    choose "Yes, I’ve completed this section", visible: false
  end

  def and_i_see_the_address_prefilled
    expect(page).to have_field("Address line 1", with: "1 Street")
    expect(page).to have_field("Town or city", with: "London")
    expect(page).to have_field("Postcode", with: "SW1A 1AA")
  end

  def and_i_see_the_name_prefilled
    expect(page).to have_field(
      "What’s the name of your organisation?",
      with: "My organisation"
    )
  end

  def and_i_see_your_organisation_flagged_as_incomplete
    your_organisation_row =
      find(".app-task-list__item", text: "Your organisation")
    expect(your_organisation_row).to have_content("INCOMPLETE")
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
  end

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_i_am_on_the_referral_summary_page
    visit edit_referral_path(@referral)
  end

  def and_i_have_an_existing_referral
    @referral = create(:referral, user: @user)
  end

  def and_i_see_your_organisation_flagged_as_complete
    within(".app-task-list__item", text: "Your organisation") do
      status_tag = find(".app-task-list__tag")
      expect(status_tag.text).to match(/^COMPLETE/)
    end
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def then_i_am_asked_to_make_a_choice
    expect(page).to have_content("Tell us if you have completed this section")
  end

  def then_i_am_on_the_organisation_address_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/organisation_address/edit"
    )
    expect(page).to have_title(
      "What is your organisation’s address? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What is your organisation’s address?")
  end

  def then_i_am_on_the_organisation_details_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/organisation")
    expect(page).to have_title(
      "Your organisation - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your organisation")
  end

  def then_i_am_on_the_organisation_name_page
    expect(page).to have_current_path(
      "/referrals/#{@referral.id}/organisation_name/edit"
    )
    expect(page).to have_title(
      "What’s the name of your organisation? - Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("What’s the name of your organisation?")
  end

  def then_i_am_on_the_referral_summary_page
    expect(page).to have_current_path(edit_referral_path(@referral))
  end

  def then_i_see_the_missing_address_errors
    expect(page).to have_content(
      "Tell us the street address for your organisation"
    )
    expect(page).to have_content("Tell us the city for your organisation")
    expect(page).to have_content("Tell us the postcode for your organisation")
  end

  def then_i_see_the_missing_name_error
    expect(page).to have_content("Tell us the name of your organisation")
  end

  def when_i_choose_no_come_back_later
    choose "No, I’ll come back to it later", visible: false
  end

  def when_i_click_change_organisation_address
    click_on "Change address"
  end

  def when_i_click_change_organisation_name
    click_on "Change name"
  end

  def when_i_click_on_your_organisation
    click_on "Your organisation"
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def when_i_complete_the_address
    fill_in "Address line 1", with: "1 Street"
    fill_in "Town or city", with: "London"
    fill_in "Postcode", with: "SW1A 1AA"
  end

  def when_i_fill_in_the_organisation_name
    fill_in "What’s the name of your organisation?", with: "My organisation"
  end

  def when_i_go_back
    page.go_back
  end
end
