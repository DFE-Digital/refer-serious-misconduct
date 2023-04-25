# frozen_string_literal: true
module Referrals
  module Allegation
    class ConsiderationsForm
      include ReferralFormSection

      validates :allegation_consideration_details, presence: true

      attr_writer :allegation_consideration_details

      def allegation_consideration_details
        @allegation_consideration_details ||= referral&.allegation_consideration_details
      end

      def save
        return false if invalid?

        referral.update(allegation_consideration_details:)
      end

      def slug
        "allegation_considerations"
      end
    end
  end
end
