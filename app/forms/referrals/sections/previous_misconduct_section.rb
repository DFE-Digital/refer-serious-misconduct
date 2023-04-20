module Referrals
  module Sections
    class PreviousMisconductSection < Section
      def items
        [
          Referrals::PreviousMisconduct::ReportedForm.new(referral:),
          Referrals::PreviousMisconduct::DetailedAccountForm.new(referral:),
          Referrals::PreviousMisconduct::CheckAnswersForm.new(referral:)
        ]
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
    end
  end
end
