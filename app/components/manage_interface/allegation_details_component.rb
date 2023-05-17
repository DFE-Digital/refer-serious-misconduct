module ManageInterface
  class AllegationDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      summary_rows [
                     allegation_details_format_row,
                     allegation_details_row,
                     complain_consideration_row,
                     told_dbs_row
                   ].compact
    end

    def title
      "Allegation details"
    end

    private

    def allegation_details_format_row
      { label: "How do you want to give details about the allegation?", value: details_format }
    end

    def allegation_details_row
      { label: "Allegation details", value: allegation_details(referral) }
    end

    def complain_consideration_row
      return unless referral.from_member_of_public?

      {
        label: "Details about how this complaint has been considered",
        value: simple_format(referral.allegation_consideration_details)
      }
    end

    def told_dbs_row
      return unless referral.from_employer?

      {
        label: "Have you told the Disclosure and Barring Service (DBS)?",
        value: referral.dbs_notified
      }
    end

    def details_format
      case referral.allegation_format
      when "details"
        "Describe the allegation"
      when "upload"
        "File upload"
      end
    end
  end
end
