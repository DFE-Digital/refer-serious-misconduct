module AuthorizationSteps
  def when_i_login_as_a_case_worker_with_management_permissions_only
    create(:staff, :confirmed, :can_manage_referrals)

    visit manage_sign_in_path

    fill_in "Email", with: "test@example.org"
    fill_in "Password", with: "Example123!"

    click_on "Log in"
  end

  def when_i_login_as_a_case_worker_without_any_permissions_at_all
    create(:staff, :confirmed)

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

  def then_i_am_unauthorized_and_redirected_to_root_path
    expect(page).to have_current_path("/start")
    expect(page).to have_content("You are not authorized to see this section.")
  end

  def then_i_see_the_staff_index
    expect(page).to have_current_path("/support/staff")
    expect(page).to have_title("Staff")
  end

  def then_i_see_manage_referrals_page
    expect(page).to have_current_path("/manage/referrals")
  end
end
