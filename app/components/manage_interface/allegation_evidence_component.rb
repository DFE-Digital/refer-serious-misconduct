module ManageInterface
  class AllegationEvidenceComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      summary_rows [evidence_row] unless referral.has_evidence
    end

    private

    def evidence_row
      { label: "Is there anything to upload?", value: "No" }
    end
  end
end
