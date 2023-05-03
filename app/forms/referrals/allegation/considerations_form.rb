# frozen_string_literal: true
module Referrals
  module Allegation
    class ConsiderationsForm
      include ReferralFormSection

      validates :allegation_consideration_details, presence: true

      attr_referral :allegation_consideration_details

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
