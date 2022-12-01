module Referrals
  module TeacherRole
    class CheckAnswersForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :teacher_role_complete

      validates :referral, presence: true
      validates :teacher_role_complete, inclusion: { in: [true, false] }

      def teacher_role_complete=(value)
        @teacher_role_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(teacher_role_complete:)
      end
    end
  end
end
