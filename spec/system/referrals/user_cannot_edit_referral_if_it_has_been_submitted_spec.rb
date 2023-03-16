# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Submitted referral", type: :system do
  include CommonSteps

  scenario "User tries to edit the referral" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_i_am_signed_in
    and_i_have_submitted_referrals

    when_i_access_a_public_submitted_referral_edit_page
    then_i_get_redirected_to_the_public_referral_page

    when_i_access_an_employer_submitted_referral_edit_page
    then_i_get_redirected_to_the_employer_referral_page
  end

  private

  def and_i_have_submitted_referrals
    @employer_referral = create(:referral, :submitted, :public, user: @user)
    @public_referral = create(:referral, :submitted, :employer, user: @user)
  end

  def when_i_access_a_public_submitted_referral_edit_page
    visit edit_referral_personal_details_name_path(@public_referral)
  end

  def then_i_get_redirected_to_the_public_referral_page
    expect(page).to have_content("Your referral")
    expect(page).to have_current_path("/users/referrals/#{@public_referral.id}")
  end

  def when_i_access_an_employer_submitted_referral_edit_page
    visit edit_public_referral_personal_details_name_path(@employer_referral)
  end

  def then_i_get_redirected_to_the_employer_referral_page
    expect(page).to have_content("Your referral")
    expect(page).to have_current_path("/users/referrals/#{@employer_referral.id}")
  end
end
