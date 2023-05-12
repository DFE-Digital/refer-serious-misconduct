module Referrals
  module TeacherRole
    class CheckAnswersForm
      include ReferralFormSection

      attr_referral :teacher_role_complete

      validates :teacher_role_complete, inclusion: { in: [true, false] }

      def save
        return false unless valid?

        referral.update(teacher_role_complete:)
      end

      def section_class
        Referrals::Sections::TeacherRoleSection
      end
    end
  end
end
