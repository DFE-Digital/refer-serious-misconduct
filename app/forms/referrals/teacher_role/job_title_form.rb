# frozen_string_literal: true
module Referrals
  module TeacherRole
    class JobTitleForm
      include ReferralFormSection

      attr_accessor :job_title

      validates :job_title, presence: true

      def save
        return false if invalid?

        referral.update(job_title:)
      end
    end
  end
end
