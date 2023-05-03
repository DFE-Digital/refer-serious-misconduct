# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class NiNumberForm
      include ReferralFormSection

      attr_referral :ni_number_known, :ni_number

      validates :ni_number,
                presence: true,
                format: {
                  with: /\A[a-z]{2}[0-9]{6}[a-d]{1}\Z/i
                },
                if: -> { ni_number_known }
      validates :ni_number_known, inclusion: { in: [true, false] }

      def ni_number=(value)
        @ni_number = value&.gsub(/\s|-/, "")
      end

      def save
        return false unless valid?

        referral.update(ni_number_known:, ni_number: ni_number_known ? ni_number : nil)
      end

      def slug
        "personal_details_ni_number"
      end
    end
  end
end
