module AuthorizationSteps
  def when_i_start_the_signin_flow
    visit root_path
    choose "Yes, sign in and continue making a referral", visible: false
    click_on "Continue"
    fill_in "user-email-field", with: "test@example.com"
    click_on "Continue"
  end

  def when_i_login_as_a_case_worker_with_management_permissions_only
    create(:staff, :confirmed, :can_manage_referrals)

    visit manage_sign_in_path

    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end

  def when_i_login_as_a_case_worker_with_support_permissions_only
    create(:staff, :confirmed, :can_view_support)

    visit manage_sign_in_path

    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end

  def when_i_visit_staff_sign_in_page
    visit manage_sign_in_path
  end

  def when_i_am_authorized_with_basic_auth_as_a_case_worker
    page.driver.basic_authorize(
      ENV.fetch("SUPPORT_USERNAME", "test"),
      ENV.fetch("SUPPORT_PASSWORD", "test")
    )
  end
  alias_method :and_i_am_authorized_with_basic_auth_as_a_case_worker,
               :when_i_am_authorized_with_basic_auth_as_a_case_worker

  def then_i_am_unauthorized
    expect(page).to have_content("You do not have permission to view this page")
  end

  def then_i_am_unauthorized_and_redirected_to_forbidden_path
    expect(page).to have_current_path("/403")
    expect(page).to have_content("You do not have permission to view this page")
  end

  def then_i_see_the_staff_index
    expect(page).to have_current_path("/support/staff")
    expect(page).to have_title("Staff")
  end

  def then_i_see_manage_referrals_page
    expect(page).to have_current_path("/manage/referrals")
  end
end
