module ManageInterface
  class EvidenceComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      unless referral.has_evidence
        [
          {
            key: {
              text: "Is there anything to upload?"
            },
            value: {
              text: "No"
            }
          }
        ]
      end
    end
  end
end
