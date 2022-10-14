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
end
