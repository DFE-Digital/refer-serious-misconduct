# frozen_string_literal: true
module Referrals
  module TeacherRole
    class WorkLocationKnownForm
      include ReferralFormSection

      attr_reader :work_location_known

      validates :work_location_known, inclusion: { in: [true, false] }

      def work_location_known=(value)
        @work_location_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(work_location_known:)
      end
    end
  end
end
