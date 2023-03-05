require "rails_helper"

RSpec.feature "User revisits", type: :system do
  include CommonSteps

  scenario "New user visits" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    when_i_visit_the_service
    then_i_see_the_do_you_have_an_account
  end

  scenario "User with existing referral visits" do
    given_the_service_is_open
    and_the_referral_form_feature_is_active
    and_the_eligibility_screener_feature_is_active
    and_i_am_signed_in
    and_i_am_a_member_of_the_public_with_an_existing_referral
    when_i_visit_the_service
    then_i_see_the_public_referral_summary
  end

  private

  def then_i_see_the_do_you_have_an_account
    expect(page).to have_content("Do you have an account?")
  end
end
