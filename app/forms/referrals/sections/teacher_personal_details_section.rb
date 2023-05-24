module Referrals
  module Sections
    class PersonalDetailsSection < Section
      def items
        [].tap do |items|
          items << Referrals::PersonalDetails::NameForm.new(referral:)

          if referral.from_employer?
            items << Referrals::PersonalDetails::AgeForm.new(referral:)
            items << Referrals::PersonalDetails::NiNumberForm.new(referral:)
            items << Referrals::PersonalDetails::TrnForm.new(referral:)
            items << Referrals::PersonalDetails::QtsForm.new(referral:)
          end

          items << Referrals::PersonalDetails::CheckAnswersForm.new(referral:)
        end
      end

      def slug
        "personal_details"
      end

      def complete?
        referral.personal_details_complete
      end

      def label
        I18n.t("referral_form.personal_details")
      end

      def view_component(**args)
        PersonalDetailsComponent.new(referral:, **args)
      end
    end
  end
end
