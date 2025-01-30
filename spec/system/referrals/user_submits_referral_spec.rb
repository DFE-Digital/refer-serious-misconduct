require "rails_helper"

RSpec.feature "User submits a referral", type: :system do
  include CommonSteps

  scenario "happy path" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_have_an_incomplete_referral
    when_i_visit_the_referral
    and_i_click_review_and_send
    then_i_see_the_check_answers_page
    and_event_tracking_is_working

    when_i_have_a_complete_referral
    and_i_visit_the_referral
    and_i_click_review_and_send
    then_i_see_the_check_answers_page
    and_i_click_send_referral
    then_i_see_the_confirmation_page
    and_event_tracking_is_working
  end

  private

  def and_i_have_an_incomplete_referral
    @referral = create(:referral, user: @user)
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/review")
    expect(page).to have_title("Check details and send report")
    expect(page).to have_content("Check details and send report")
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/confirmation")
    expect(page).to have_title("Referral sent")
    expect(page).to have_content("Referral sent")
  end

  def then_i_see_the_declaration_page
    expect(page).to have_current_path("/referrals/#{@referral.id}/declaration")
    expect(page).to have_title("Before you send your referral")
    expect(page).to have_content("Before you send your referral")
  end

  def then_i_see_the_missing_declaration_error
    expect(page).to have_content("You must agree to the declaration")
  end

  def when_i_click_send_referral
    click_on "Agree and send referral"
  end
  alias_method :and_i_click_send_referral, :when_i_click_send_referral

  def when_i_complete_the_declaration
    check "Yes, I agree", allow_label_click: true
  end

  def when_i_have_a_complete_referral
    @referral.update(attributes_for(:referral, :complete))
    create(:organisation, :complete, referral: @referral)
    create(:referrer, :complete, referral: @referral)
  end
end
