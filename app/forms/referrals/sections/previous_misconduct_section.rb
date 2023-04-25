module Referrals
  module Sections
    class PreviousMisconductSection < Section
      def items
        [
          Referrals::PreviousMisconduct::ReportedForm.new(referral:),
          referral.previous_misconduct_reported? &&
            Referrals::PreviousMisconduct::DetailedAccountForm.new(referral:),
          Referrals::PreviousMisconduct::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def slug
        "previous_misconduct"
      end

      def complete?
        referral.previous_misconduct_complete
      end

      def label
        I18n.t("referral_form.previous_allegations")
      end

      def view_component(**args)
        PreviousMisconductComponent.new(referral:, **args)
      end
    end
  end
end
