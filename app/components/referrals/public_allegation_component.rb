module Referrals
  class PublicAllegationComponent < ReferralFormBaseComponent
    def rows
      summary_rows [
                     allegation_details_format_row,
                     allegation_details_description_row,
                     allegation_details_considerations_row
                   ].compact
    end

    private

    def allegation_details_format_row
      {
        label: "How do you want to give details about the allegation?",
        visually_hidden_text: "how you want to give details about the allegation",
        value: allegation_details_format(referral),
        path: :details
      }
    end

    def allegation_details_description_row
      {
        label: "Description of the allegation",
        value: allegation_details(referral),
        path: :details
      }
    end

    def allegation_details_considerations_row
      {
        label: "Details about how this complaint has been considered",
        value:
          simple_format(nullable_value_to_s(referral.allegation_consideration_details.presence)),
        path: :considerations
      }
    end

    def section
      Referrals::Sections::AllegationDetailsSection.new(referral:)
    end
  end
end
