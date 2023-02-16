module AuthorizationSteps
  def when_i_am_authorized_as_a_case_worker_with_management_permissions
    user = create(:staff, :confirmed, :can_view_support, :can_manage_referrals)

    sign_in(user)
  end

  def when_i_am_authorized_as_a_case_worker_without_management_permissions
    user = create(:staff, :confirmed, :can_view_support)

    sign_in(user)
  end

  def when_i_am_authorized_as_a_case_worker_with_support_permissions
    user = create(:staff, :confirmed, :can_view_support)

    sign_in(user)
  end

  def when_i_am_authorized_as_a_case_worker_without_support_permissions
    user = create(:staff, :confirmed)

    sign_in(user)
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
end
