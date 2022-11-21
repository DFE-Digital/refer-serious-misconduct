# frozen_string_literal: true
module Referrals
  module TeacherRole
    class JobTitleForm
      include ActiveModel::Model

      attr_accessor :referral, :job_title

      validates :referral, presence: true
      validates :job_title, presence: true

      def save
        return false if invalid?

        referral.update(job_title:)
      end
    end
  end
end
