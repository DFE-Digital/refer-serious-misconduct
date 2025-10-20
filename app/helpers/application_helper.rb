module ApplicationHelper
  def link_to_referral_form_for(reporting_as = "public")
    link = {
      employer: {
        title:
          "download and print the teacher misconduct form for use by employers (opens in a new tab)",
        url:
          "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1105692/Teacher_Misconduct_Referral_Form_for__Employers__8_.docx"
      },
      public: {
        title:
          "download and print the teacher misconduct form for use by members of the public (opens in a new tab)",
        url:
          "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1105693/Teacher_misconduct_referral_form_for_members_of_the_public.docx"
      }
    }.with_indifferent_access

    link_to link[reporting_as][:title], link[reporting_as][:url], target: "_blank", rel: "noopener"
  end

  def current_namespace
    request.path.split("/").second
  end

  def navigation
    govuk_service_navigation(
      service_name:,
      navigation_items:
    )
  end

  def navigation_items
    [].tap do |navigation_items_array|
      case current_namespace
      when "manage", "staff", "support", "developer", "admin"
        if current_staff
          if current_staff.manage_referrals?
            navigation_items_array << {
              current: current_page?(main_app.manage_interface_referrals_path),
              href: main_app.manage_interface_referrals_path,
              text: "Referrals"
            }
          end

          if current_staff.view_support?
            navigation_items_array << {
              current: current_page?(main_app.support_interface_validation_errors_path),
              href: main_app.support_interface_validation_errors_path,
              text: "Validation Errors"
            }
            navigation_items_array << {
              current: current_page?(main_app.support_interface_eligibility_checks_path),
              href: main_app.support_interface_eligibility_checks_path,
              text: "Eligibility Checks"
            }
            navigation_items_array << {
              current: request.path.start_with?("/support/staff"),
              text: "Staff",
              href: main_app.support_interface_staff_index_path
            }
          end

          if policy(:admin).index?
            navigation_items_array << {
              current: request.path.start_with?("/admin/feedback"),
              text: "Feedback",
              href: main_app.admin_interface_feedback_index_path
            }
          end

          if current_staff.view_support? && HostingEnvironment.test_environment?
            navigation_items_array << {
              current: request.path.start_with?(main_app.support_interface_test_users_path),
              text: "Test Users",
              href: main_app.support_interface_test_users_path
            }
          end

          if current_staff.developer?
            navigation_items_array << {
              current: current_page?(main_app.developer_interface_feature_flags_path),
              href: main_app.developer_interface_feature_flags_path,
              text: "Features"
            }
          end

          navigation_items_array << { href: main_app.manage_sign_out_path, text: "Sign out" }
        end
      else
        if FeatureFlags::FeatureFlag.active?(:referral_form)
          navigation_items_array << if current_user
                                      { href: main_app.users_sign_out_path, text: "Sign out" }
                                    else
                                      { href: main_app.new_user_session_path, text: "Sign in" }
                                    end
        end
      end
    end
  end

  def humanize_three_way_choice(choice)
    { "true" => "Yes", "false" => "No", "not_sure" => "I’m not sure" }[choice]
  end

  def service_name
    return t("service.manage") if %w[manage support staff].include?(current_namespace)

    t("service.name")
  end
end
