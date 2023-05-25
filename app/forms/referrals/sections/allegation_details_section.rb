module Referrals
  module Sections
    class AllegationDetailsSection < Section
      def items
        [
          Referrals::AllegationDetails::DetailsForm.new(referral:),
          referral.from_member_of_public? &&
            Referrals::AllegationDetails::ConsiderationsForm.new(referral:),
          referral.from_employer? && Referrals::AllegationDetails::DbsForm.new(referral:),
          Referrals::AllegationDetails::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.allegation_details_complete
      end

      def view_component(**args)
        if referral.from_member_of_public?
          PublicAllegationComponent.new(referral:, **args)
        else
          AllegationDetailsComponent.new(referral:, **args)
        end
      end
    end
  end
end
