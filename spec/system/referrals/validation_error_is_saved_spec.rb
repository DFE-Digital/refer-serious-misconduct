require "rails_helper"

RSpec.feature "User triggers a validation error which gets saved", type: :system do
  include CommonSteps

  scenario "happy path" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_incomplete_referral
    when_i_visit_the_referral

    when_i_edit_personal_details
    and_i_am_asked_their_name
    and_i_click_save_and_continue
    then_i_see_name_field_validation_errors
    and_the_validation_errors_are_saved
  end

  private

  def and_i_have_an_incomplete_referral
    @referral = create(:referral, user: @user)
  end

  def when_i_edit_personal_details
    within(all(".app-task-list__section")[1]) { click_on "Personal details" }
  end

  def and_i_am_asked_their_name
    expect(page).to have_content("Personal details")
    expect(page).to have_content("Their name")
  end

  def then_i_see_name_field_validation_errors
    expect(page).to have_content("Enter their first name")
    expect(page).to have_content("Enter their last name")
  end

  def and_the_validation_errors_are_saved
    expect(ValidationError.count).to eq(1)
    expect(ValidationError.first.form_object).to eq("Referrals::TeacherPersonalDetails::NameForm")
  end
end
