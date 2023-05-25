# frozen_string_literal: true
module Referrals
  module AllegationEvidence
    class CheckAnswersForm < FormItem
      validates :evidence_details_complete, inclusion: { in: [true, false] }

      attr_referral :evidence_details_complete

      def save
        return false if invalid?

        referral.update(evidence_details_complete:)
      end
    end
  end
end
