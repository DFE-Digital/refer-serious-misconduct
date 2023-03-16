module ManageInterface
  class AllegationDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "How do you want to give details about the allegation?" }, value: { text: details_format } },
        { key: { text: "Allegation details" }, value: { text: allegation_details(referral) } }
      ]

      if referral.from_member_of_public?
        rows.push(
          {
            key: {
              text: "Details about how this complaint has been considered"
            },
            value: {
              text: simple_format(referral.allegation_consideration_details)
            }
          }
        )
      end

      return rows unless referral.from_employer?

      rows.push(
        {
          key: {
            text: "Have you told the Disclosure and Barring Service (DBS)?"
          },
          value: {
            text: referral.dbs_notified ? "Yes" : "No"
          }
        }
      )

      rows
    end

    def title
      "Allegation details"
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
