module Referrals
  module Sections
    class PersonalDetailsSection < Section
      def items
        items = [Referrals::PersonalDetails::NameForm.new(referral:)]

        if referral.from_employer?
          items.append(Referrals::PersonalDetails::AgeForm.new(referral:))
          items.append(Referrals::PersonalDetails::NiNumberForm.new(referral:))
          items.append(Referrals::PersonalDetails::TrnForm.new(referral:))
          items.append(Referrals::PersonalDetails::QtsForm.new(referral:))
        end

        items.append(Referrals::PersonalDetails::CheckAnswersForm.new(referral:))
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
