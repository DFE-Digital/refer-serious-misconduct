require "rails_helper"

RSpec.feature "A member of the public submits a referral", type: :system do
  include CommonSteps

  around do |example|
    Capybara.raise_server_errors = false
    example.run
    Capybara.raise_server_errors = true
  end

  scenario "A successful submission" do
    given_the_service_is_open
    and_i_am_signed_in
    and_the_referral_form_feature_is_active
    and_i_am_a_member_of_the_public_with_an_existing_referral
    when_i_visit_the_public_referral
    and_i_click_review_and_send
    then_i_see_the_check_answers_page
    and_event_tracking_is_working

    when_i_have_a_complete_referral
    and_i_visit_the_public_referral
    and_i_click_review_and_send
    then_i_see_the_check_answers_page
    and_i_click_send_referral
    then_i_see_the_confirmation_page
    then_i_see_a_referral_submitted_email
    and_event_tracking_is_working

    when_i_try_to_edit_the_referral
    and_i_click_save_and_continue
    then_i_get_an_error
  end

  private

  def and_i_click_review_and_send
    click_on "Review and send"
  end

  def then_i_see_the_check_answers_page
    expect(page).to have_current_path(public_referral_review_path(@referral))
    expect(page).to have_title("Check details and send referral")
    expect(page).to have_content("Check details and send referral")
  end

  def then_i_see_the_confirmation_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/confirmation"
    )
    expect(page).to have_title("Referral sent")
    expect(page).to have_content("Referral sent")
  end

  def then_i_see_the_declaration_page
    expect(page).to have_current_path(
      "/public-referrals/#{@referral.id}/declaration"
    )
    expect(page).to have_title("Before you send your referral")
    expect(page).to have_content("Before you send your referral")
  end

  def then_i_see_the_missing_declaration_error
    expect(page).to have_content("You must agree to the declaration")
  end

  def then_i_see_the_missing_sections_error
    expect(page).to have_content("Complete all sections of the referral")
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
    create(:organisation, complete: true, referral: @referral)
    create(:referrer, complete: true, referral: @referral)
  end

  def then_i_see_a_referral_submitted_email
    perform_enqueued_jobs
    message = ActionMailer::Base.deliveries.last
    expect(message.subject).to eq(
      "Your referral of serious misconduct has been sent"
    )
    expect(message.to).to include(@referral.user.email)
    expect(message.body).to include(users_referral_path(@referral))
  end

  def and_event_tracking_is_working
    expect(
      %i[create_entity update_entity]
    ).to have_been_enqueued_as_analytics_events
  end

  def when_i_try_to_edit_the_referral
    visit edit_public_referral_referrer_phone_path(@referral)
    fill_in "Your phone number", with: "01234567890"
  end

  def then_i_get_an_error
    expect(page).to have_content("ActionController::RoutingError")
  end
end
