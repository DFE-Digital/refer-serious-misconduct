module Referrals
  module Sections
    class ReferrerSection < Section
      def items
        [
          Referrer::NameForm.new(referral:),
          referral.from_employer? && Referrer::JobTitleForm.new(referral:),
          Referrer::PhoneForm.new(referral:),
          Referrer::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def slug
        "referrer"
      end

      def complete?
        referral.referrer&.complete
      end

      def label
        I18n.t("referral_form.your_details")
      end

      def view_component(**args)
        AboutYouComponent.new(referral:, **args)
      end
    end
  end
end
