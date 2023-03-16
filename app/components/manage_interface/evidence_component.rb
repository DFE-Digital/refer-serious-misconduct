module ManageInterface
  class EvidenceComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      [{ key: { text: "Is there anything to upload?" }, value: { text: "No" } }] unless referral.has_evidence
    end
  end
end
