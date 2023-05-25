module Referrals
  module Sections
    class AllegationPreviousSection < Section
      def items
        [
          Referrals::AllegationPrevious::ReportedForm.new(referral:),
          referral.previous_misconduct_reported? &&
            Referrals::AllegationPrevious::DetailedAccountForm.new(referral:),
          Referrals::AllegationPrevious::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.previous_misconduct_complete
      end

      def view_component(**args)
        AllegationPreviousComponent.new(referral:, **args)
      end
    end
  end
end
