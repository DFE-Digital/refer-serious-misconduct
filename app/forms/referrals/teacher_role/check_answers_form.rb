module Referrals
  module TeacherRole
    class CheckAnswersForm
      include ReferralFormSection

      attr_reader :teacher_role_complete

      validates :teacher_role_complete, inclusion: { in: [true, false] }

      def teacher_role_complete=(value)
        @teacher_role_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

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
