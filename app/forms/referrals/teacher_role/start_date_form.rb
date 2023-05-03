# frozen_string_literal: true
module Referrals
  module TeacherRole
    class StartDateForm
      include ReferralFormSection

      attr_accessor :date_params
      attr_referral :role_start_date_known, :role_start_date

      validates :role_start_date_known, inclusion: { in: [true, false] }
      validates :role_start_date,
                date: {
                  not_future: true,
                  past_century: true
                },
                if: -> { role_start_date_known }

      def save
        return false if invalid?

        referral.update(role_start_date:, role_start_date_known:)
      end

      def slug
        "teacher_role_start_date"
      end
    end
  end
end
