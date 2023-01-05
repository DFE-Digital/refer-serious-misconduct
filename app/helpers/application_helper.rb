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

  def humanize_three_way_choice(choice)
    { "true" => "Yes", "false" => "No", "not_sure" => "I’m not sure" }[choice]
  end

  def return_to_session_or(url)
    session[:return_to] || url
  end
end
