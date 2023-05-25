module Referrals
  module Sections
    class TeacherContactDetailsSection < Section
      def items
        [
          referral.from_employer? && Referrals::TeacherContactDetails::EmailForm.new(referral:),
          Referrals::TeacherContactDetails::TelephoneForm.new(referral:),
          Referrals::TeacherContactDetails::AddressKnownForm.new(referral:),
          referral.address_known? && Referrals::TeacherContactDetails::AddressForm.new(referral:),
          Referrals::TeacherContactDetails::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.contact_details_complete
      end

      def view_component(**args)
        TeacherContactDetailsComponent.new(referral:, **args)
      end
    end
  end
end
