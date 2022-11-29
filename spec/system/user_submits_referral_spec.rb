require "rails_helper"

RSpec.feature "User submits a referral", type: :system do
  scenario "happy path" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_employer_form_feature_is_active
    and_the_user_accounts_feature_is_active
    and_i_have_an_incomplete_referral
    when_i_visit_the_referral_summary
    and_i_click_review_and_send
    then_i_see_the_missing_sections_error

    when_i_have_a_complete_referral
    and_i_click_review_and_send
    then_i_see_the_confirmation_page
  end

  private

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def and_i_click_review_and_send
    click_on "Review and send"
  end

  def and_i_have_an_incomplete_referral
    @referral = create(:referral, user: @user)
  end

  def and_the_employer_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:employer_form)
  end

  def and_the_user_accounts_feature_is_active
    FeatureFlags::FeatureFlag.activate(:user_accounts)
  end

  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/confirmation")
    expect(page).to have_title("We have received your referral")
    expect(page).to have_content("We have received your referral")
  end

  def then_i_see_the_missing_sections_error
    expect(page).to have_content("Please complete all sections of the referral")
  end

  def when_i_have_a_complete_referral
    @referral.update(attributes_for(:referral, :complete))
    create(:organisation, completed_at: Time.current, referral: @referral)
    create(:referrer, completed_at: Time.current, referral: @referral)
  end

  def when_i_visit_the_referral_summary
    visit edit_referral_path(@referral)
  end
end
