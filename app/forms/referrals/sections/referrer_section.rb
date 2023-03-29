module Referrals
  module Sections
    class ReferrerSection < Section
      def items
        [
          Referrer::NameForm.new(referral:),
          Referrer::JobTitleForm.new(referral:),
          Referrer::PhoneForm.new(referral:),
          Referrer::CheckAnswersForm.new(referral:)
        ]
      end

      def complete
        referral.referrer&.complete
      end

      def label
        I18n.t("referral_form.your_details")
      end

      def view_component(user:)
        AboutYouComponent.new(referral:, user:, section: self)
      end
    end
  end
end
