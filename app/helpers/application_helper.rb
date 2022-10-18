module ApplicationHelper
  def link_to_referral_form_for(reporting_as = "public")
    link = {
      employer: {
        title: "Teacher misconduct referral form for use by employers",
        url:
          "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1105692/Teacher_Misconduct_Referral_Form_for__Employers__8_.docx"
      },
      public: {
        title:
          "Teacher misconduct referral form for use by members of the public",
        url:
          "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1105693/Teacher_misconduct_referral_form_for_members_of_the_public.docx"
      }
    }.with_indifferent_access

    link_to link[reporting_as][:title], link[reporting_as][:url]
  end

  def current_namespace
    request.path.split("/").second
  end

  def navigation
    govuk_header(service_name: t('service.name')) do |header|
      case current_namespace
      when "support"
        header.navigation_item(
        active: current_page?(main_app.support_interface_eligibility_checks_path),
        href: main_app.support_interface_eligibility_checks_path,
        text: "Eligibility Checks",
        ) 
        header.navigation_item(
          active: current_page?(main_app.support_interface_feature_flags_path),
          href: main_app.support_interface_feature_flags_path,
          text: "Features",
        )
      end
    end
  end
end
