# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class TrnForm
      include ReferralFormSection

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

      def trn_known
        return @trn_known if defined?(@trn_known)
        @trn_known = referral&.trn_known
      end

      def trn_known=(value)
        @trn_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def trn
        @trn ||= referral&.trn&.strip
      end

      def trn=(value)
        @trn = value&.strip
      end

      def save
        referral.update(trn_known:, trn: trn_known ? trn : nil) if valid?
      end

      def slug
        "personal_details_trn"
      end
    end
  end
end
