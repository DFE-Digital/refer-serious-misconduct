# frozen_string_literal: true
module Referrals
  module AllegationEvidence
    class StartForm < FormItem
      attr_referral :has_evidence

      validates :has_evidence, inclusion: { in: [true, false] }

      def save
        return false if invalid?

        referral
          .update(has_evidence:)
          .tap { |result| referral.evidence_uploads.destroy_all if result && !has_evidence }
      end
    end
  end
end
