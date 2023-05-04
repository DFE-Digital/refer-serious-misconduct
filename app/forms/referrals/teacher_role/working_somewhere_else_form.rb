# frozen_string_literal: true
module Referrals
  module TeacherRole
    class WorkingSomewhereElseForm
      include ReferralFormSection

      attr_referral :working_somewhere_else

      validates :working_somewhere_else, inclusion: { in: %w[yes no not_sure] }

      def save
        return false if invalid?

        referral.update(working_somewhere_else:)
      end
    end
  end
end
