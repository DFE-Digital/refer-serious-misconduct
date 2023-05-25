module Referrals
  module Sections
    class ReferrerDetailsSection < Section
      def items
        [
          ReferrerDetails::NameForm.new(referral:),
          referral.from_employer? && ReferrerDetails::JobTitleForm.new(referral:),
          ReferrerDetails::PhoneForm.new(referral:),
          ReferrerDetails::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.referrer&.complete
      end

      def view_component(**args)
        ReferrerDetailsComponent.new(referral:, **args)
      end
    end
  end
end
