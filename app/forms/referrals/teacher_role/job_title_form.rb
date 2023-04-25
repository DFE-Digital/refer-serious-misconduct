# frozen_string_literal: true
module Referrals
  module TeacherRole
    class JobTitleForm
      include ReferralFormSection

      attr_writer :job_title

      validates :job_title, presence: true

      def job_title
        @job_title ||= referral&.job_title
      end

      def save
        return false if invalid?

        referral.update(job_title:)
      end

      def slug
        "teacher_role_job_title"
      end
    end
  end
end
