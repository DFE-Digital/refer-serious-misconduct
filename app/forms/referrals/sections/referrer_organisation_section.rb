module Referrals
  module Sections
    class ReferrerOrganisationSection < Section
      def items
        [
          ReferrerOrganisation::AddressForm.new(referral:),
          ReferrerOrganisation::CheckAnswersForm.new(referral:)
        ]
      end

      def complete?
        referral.organisation&.complete
      end

      def view_component(**args)
        ReferrerOrganisationComponent.new(referral:, **args)
      end
    end
  end
end
