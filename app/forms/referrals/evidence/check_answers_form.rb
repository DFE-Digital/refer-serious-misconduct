# frozen_string_literal: true
module Referrals
  module Evidence
    class CheckAnswersForm
      include ReferralFormSection

      validates :evidence_details_complete, inclusion: { in: [true, false] }

      attr_reader :evidence_details_complete

      def evidence_details_complete=(value)
        @evidence_details_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(evidence_details_complete:)
      end
    end
  end
end
