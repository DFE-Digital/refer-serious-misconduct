# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Referral route constraints", type: :system do
  include CommonSteps

  around do |example|
    Capybara.raise_server_errors = false
    example.run
    Capybara.raise_server_errors = true
  end

  scenario "User tries to edit referral via wrong path" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_i_am_signed_in
    and_i_have_two_different_types_of_referral

    when_i_edit_a_public_referral_via_an_employer_path
    then_i_get_an_error

    when_i_edit_an_employer_referral_via_a_public_path
    then_i_get_an_error

    when_the_referral_type_and_path_are_consistent
    then_i_do_not_get_an_error
  end

  private

  def and_i_have_two_different_types_of_referral
    @employer_referral = create(:referral, user: @user)
    @public_referral =
      create(
        :referral,
        user: @user,
        eligibility_check: create(:eligibility_check, :public)
      )

    visit root_path
  end

  def when_i_edit_a_public_referral_via_an_employer_path
    visit edit_referral_personal_details_name_path(@public_referral)
  end

  def then_i_get_an_error
    expect(page).to have_content("ActionController::RoutingError")
  end

  def when_i_edit_an_employer_referral_via_a_public_path
    visit edit_public_referral_personal_details_name_path(@employer_referral)
  end

  def when_the_referral_type_and_path_are_consistent
    visit edit_public_referral_personal_details_name_path(@public_referral)
  end

  def then_i_do_not_get_an_error
    expect(page).not_to have_content("ActionController::RoutingError")
    expect(page).to have_content "Their name"
  end
end
