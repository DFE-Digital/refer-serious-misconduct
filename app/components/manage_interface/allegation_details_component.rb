module ManageInterface
  class AllegationDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      [
        {
          key: {
            text: "Allegation details"
          },
          value: {
            text: allegation_details(referral)
          }
        },
        {
          key: {
            text: "Have you told the Disclosure and Barring Service (DBS)?"
          },
          value: {
            text: referral.dbs_notified ? "Yes" : "No"
          }
        }
      ]
    end

    def title
      "Allegation details"
    end
  end
end
