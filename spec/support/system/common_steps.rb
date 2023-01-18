module CommonSteps
  def given_the_service_is_open
    FeatureFlags::FeatureFlag.activate(:service_open)
  end

  def and_staff_http_basic_is_active
    FeatureFlags::FeatureFlag.activate(:staff_http_basic_auth)
  end

  def and_i_am_signed_in
    @user = create(:user)
    sign_in(@user)
  end

  def when_i_visit_the_service
    visit root_path
  end

  def and_the_referral_form_feature_is_active
    FeatureFlags::FeatureFlag.activate(:referral_form)
  end

  def and_the_eligibility_screener_feature_is_active
    FeatureFlags::FeatureFlag.activate(:eligibility_screener)
  end

  def and_i_have_an_existing_referral
    @referral = create(:referral, user: @user)
  end
  alias_method :when_i_have_an_existing_referral,
               :and_i_have_an_existing_referral

  def and_i_am_a_member_of_the_public_with_an_existing_referral
    @referral =
      create(
        :referral,
        eligibility_check: create(:eligibility_check, :public),
        user: @user
      )
  end

  def and_i_visit_the_referral
    visit edit_referral_path(@referral)
  end
  alias_method :when_i_visit_the_referral, :and_i_visit_the_referral

  def and_i_visit_the_public_referral
    visit edit_public_referral_path(@referral)
  end
  alias_method :when_i_visit_the_public_referral,
               :and_i_visit_the_public_referral

  def then_i_see_the_referral_summary
    expect(page).to have_current_path(edit_referral_path(@referral))
    expect(page).to have_title(
      "Refer serious misconduct by a teacher in England"
    )
    expect(page).to have_content("Your allegation of serious misconduct")
  end

  def then_i_see_the_public_referral_summary
    expect(page).to have_current_path(edit_public_referral_path(@referral))
    expect(page).to have_title(
      "Refer serious misconduct by a teacher in England"
    )
  end

  def when_i_click_save_and_continue
    click_on "Save and continue"
  end
  alias_method :and_i_click_save_and_continue, :when_i_click_save_and_continue

  def when_i_click_back
    click_on "Back"
  end
  alias_method :and_i_click_back, :when_i_click_back
end
