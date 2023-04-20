module Referrals
  module Sections
    class ReferralContactDetailsSection < Section
      def items
        [
          Referrals::ContactDetails::EmailForm.new(referral:),
          Referrals::ContactDetails::TelephoneForm.new(referral:),
          Referrals::ContactDetails::AddressKnownForm.new(referral:),
          referral.address_known? && Referrals::ContactDetails::AddressForm.new(referral:),
          Referrals::ContactDetails::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def slug
        "contact_details"
      end

      def complete?
        referral.contact_details_complete
      end
    end
  end
end
