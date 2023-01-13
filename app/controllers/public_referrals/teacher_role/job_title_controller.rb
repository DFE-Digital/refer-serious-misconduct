module PublicReferrals
  module TeacherRole
    class JobTitleController < Referrals::TeacherRole::JobTitleController
      private

      def next_path
        edit_public_referral_teacher_role_duties_path(current_referral)
      end

      def update_path
        public_referral_teacher_role_job_title_path(current_referral)
      end

      def back_link
        edit_public_referral_path(current_referral)
      end
    end
  end
end
