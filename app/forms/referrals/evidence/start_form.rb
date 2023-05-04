# frozen_string_literal: true
module Referrals
  module Evidence
    class StartForm
      include ReferralFormSection

      attr_referral :has_evidence

      validates :has_evidence, inclusion: { in: [true, false] }

      def slug
        "evidence_start"
      end

      def save
        return false if invalid?

        referral
          .update(has_evidence:)
          .tap { |result| referral.evidences.destroy_all if result && !has_evidence }
      end
    end
  end
end
