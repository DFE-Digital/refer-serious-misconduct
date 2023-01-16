module PublicReferrals
  module TeacherRole
    class CheckAnswersController < Referrals::TeacherRole::CheckAnswersController
      private

      def next_path
        edit_public_referral_path(current_referral)
      end

      def update_path
        public_referral_teacher_role_check_answers_path(current_referral)
      end
    end
  end
end
