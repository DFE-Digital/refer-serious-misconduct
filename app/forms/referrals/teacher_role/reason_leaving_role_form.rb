# frozen_string_literal: true
module Referrals
  module TeacherRole
    class ReasonLeavingRoleForm < FormItem
      attr_referral :reason_leaving_role

      validates :reason_leaving_role, inclusion: { in: %w[resigned dismissed retired unknown] }

      def save
        return false if invalid?

        referral.update(reason_leaving_role:)
      end
    end
  end
end
