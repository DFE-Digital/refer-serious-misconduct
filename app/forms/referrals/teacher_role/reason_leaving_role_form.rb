# frozen_string_literal: true
module Referrals
  module TeacherRole
    class ReasonLeavingRoleForm
      include ReferralFormSection

      attr_writer :reason_leaving_role

      validates :reason_leaving_role, inclusion: { in: %w[resigned dismissed retired unknown] }

      def reason_leaving_role
        @reason_leaving_role ||= referral&.reason_leaving_role
      end

      def save
        return false if invalid?

        referral.update(reason_leaving_role:)
      end

      def slug
        "teacher_role_reason_leaving_role"
      end
    end
  end
end
