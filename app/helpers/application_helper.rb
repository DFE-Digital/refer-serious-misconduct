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

    link_to link[reporting_as][:title],
            link[reporting_as][:url],
            target: "_blank",
            rel: "noopener"
  end

  def current_namespace
    request.path.split("/").second
  end

  def navigation
    govuk_header(service_name: t("service.name")) do |header|
      case current_namespace
      when "support"
        header.navigation_item(
          active:
            current_page?(main_app.support_interface_eligibility_checks_path),
          href: main_app.support_interface_eligibility_checks_path,
          text: "Eligibility Checks"
        )
        header.navigation_item(
          active: current_page?(main_app.support_interface_feature_flags_path),
          href: main_app.support_interface_feature_flags_path,
          text: "Features"
        )
        header.navigation_item(
          active: request.path.start_with?("/support/staff"),
          text: "Staff",
          href: main_app.support_interface_staff_index_path
        )
        if current_staff
          header.navigation_item(
            href: main_app.staff_sign_out_path,
            text: "Sign out"
          )
        end
      end

      if FeatureFlags::FeatureFlag.active?(:user_accounts)
        if current_user
          header.navigation_item(
            href: main_app.users_sign_out_path,
            text: "Sign out"
          )
        else
          header.navigation_item(
            href: main_app.new_user_session_path,
            text: "Sign in"
          )
        end
      end
    end
  end
end
