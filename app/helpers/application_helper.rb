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
    govuk_header(service_name:) do |header|
      case current_namespace
      when "manage", "staff"
        if current_staff # TODO: replace with case worker user type
          header.with_navigation_item(
            active: current_page?(main_app.manage_interface_referrals_path),
            href: main_app.manage_interface_referrals_path,
            text: "Referrals"
          )
          if current_staff.view_support?
            header.with_navigation_item(
              active: current_page?(main_app.support_interface_validation_errors_path),
              href: main_app.support_interface_validation_errors_path,
              text: "Validation Errors"
            )
            header.with_navigation_item(
              active: current_page?(main_app.support_interface_eligibility_checks_path),
              href: main_app.support_interface_eligibility_checks_path,
              text: "Eligibility Checks"
            )
            header.with_navigation_item(
              active: current_page?(main_app.support_interface_feature_flags_path),
              href: main_app.support_interface_feature_flags_path,
              text: "Features"
            )
            header.with_navigation_item(
              active: request.path.start_with?("/support/staff"),
              text: "Staff",
              href: main_app.support_interface_staff_index_path
            )
            if HostingEnvironment.test_environment?
              header.with_navigation_item(
                active: request.path.start_with?(main_app.support_interface_test_users_path),
                text: "Test Users",
                href: main_app.support_interface_test_users_path
              )
            end
          end
          header.with_navigation_item(href: main_app.manage_sign_out_path, text: "Sign out")
        end
      when "support"
        if current_staff.manage_referrals?
          header.with_navigation_item(
            active: current_page?(main_app.manage_interface_referrals_path),
            href: main_app.manage_interface_referrals_path,
            text: "Referrals"
          )
        end
        header.with_navigation_item(
          active: current_page?(main_app.support_interface_validation_errors_path),
          href: main_app.support_interface_validation_errors_path,
          text: "Validation Errors"
        )
        header.with_navigation_item(
          active: current_page?(main_app.support_interface_eligibility_checks_path),
          href: main_app.support_interface_eligibility_checks_path,
          text: "Eligibility Checks"
        )
        header.with_navigation_item(
          active: current_page?(main_app.support_interface_feature_flags_path),
          href: main_app.support_interface_feature_flags_path,
          text: "Features"
        )
        header.with_navigation_item(
          active: request.path.start_with?("/support/staff"),
          text: "Staff",
          href: main_app.support_interface_staff_index_path
        )
        if HostingEnvironment.test_environment?
          header.with_navigation_item(
            active: request.path.start_with?(main_app.support_interface_test_users_path),
            text: "Test Users",
            href: main_app.support_interface_test_users_path
          )
        end

        if current_staff
          header.with_navigation_item(href: main_app.manage_sign_out_path, text: "Sign out")
        end
      else
        if FeatureFlags::FeatureFlag.active?(:referral_form)
          if current_user
            header.with_navigation_item(href: main_app.users_sign_out_path, text: "Sign out")
          else
            header.with_navigation_item(href: main_app.new_user_session_path, text: "Sign in")
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
