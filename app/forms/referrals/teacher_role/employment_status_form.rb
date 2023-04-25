# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EmploymentStatusForm
      include ReferralFormSection

      attr_writer :employment_status

      validates :employment_status, inclusion: { in: %w[employed suspended left_role] }

      def employment_status
        @employment_status ||= referral&.employment_status
      end

      def save
        return false if invalid?

        referral.update(employment_status:)
      end

      def slug
        "teacher_role_employment_status"
      end
    end
  end
end
