# frozen_string_literal: true
module Referrals
  module TeacherRole
    class WorkLocationKnownForm
      include ReferralFormSection

      attr_referral :work_location_known

      validates :work_location_known, inclusion: { in: [true, false] }

      def save
        return false if invalid?

        referral.update(work_location_known:)
      end
    end
  end
end
