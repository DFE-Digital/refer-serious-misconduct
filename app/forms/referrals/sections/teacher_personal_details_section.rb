module Referrals
  module Sections
    class TeacherPersonalDetailsSection < Section
      def items
        [].tap do |items|
          items << Referrals::TeacherPersonalDetails::NameForm.new(referral:)

          if referral.from_employer?
            items << Referrals::TeacherPersonalDetails::AgeForm.new(referral:)
            items << Referrals::TeacherPersonalDetails::NiNumberForm.new(referral:)
            items << Referrals::TeacherPersonalDetails::TrnForm.new(referral:)
            items << Referrals::TeacherPersonalDetails::QtsForm.new(referral:)
          end

          items << Referrals::TeacherPersonalDetails::CheckAnswersForm.new(referral:)
        end
      end

      def complete?
        referral.personal_details_complete
      end

      def view_component(**args)
        TeacherPersonalDetailsComponent.new(referral:, **args)
      end
    end
  end
end
