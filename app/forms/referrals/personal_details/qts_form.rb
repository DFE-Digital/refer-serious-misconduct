# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class QtsForm
      include ReferralFormSection

      attr_writer :has_qts

      validates :has_qts, inclusion: { in: %w[yes no not_sure] }

      def has_qts
        @has_qts || referral&.has_qts
      end

      def save
        referral.update(has_qts:) if valid?
      end

      def slug
        "personal_details_qts"
      end
    end
  end
end
