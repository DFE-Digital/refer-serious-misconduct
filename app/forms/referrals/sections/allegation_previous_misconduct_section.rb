module Referrals
  module Sections
    class AllegationPreviousMisconductSection < Section
      def items
        [
          Referrals::AllegationPreviousMisconduct::ReportedForm.new(referral:),
          referral.previous_misconduct_reported? &&
            Referrals::AllegationPreviousMisconduct::DetailedAccountForm.new(referral:),
          Referrals::AllegationPreviousMisconduct::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.previous_misconduct_complete
      end

      def view_component(**args)
        AllegationPreviousMisconductComponent.new(referral:, **args)
      end
    end
  end
end
