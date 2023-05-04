# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class TrnForm
      include ReferralFormSection

      attr_referral :trn_known, :trn

      validates :trn_known, inclusion: { in: [true, false] }
      validates :trn,
                presence: true,
                length: {
                  is: 7
                },
                numericality: {
                  only_numeric: true
                },
                if: -> { trn_known }

      def save
        referral.update(trn_known:, trn: trn_known ? trn : nil) if valid?
      end
    end
  end
end
