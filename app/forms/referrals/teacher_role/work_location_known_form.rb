# frozen_string_literal: true
module Referrals
  module TeacherRole
    class WorkLocationKnownForm
      include ReferralFormSection

      validates :work_location_known, inclusion: { in: [true, false] }

      def work_location_known
        return @work_location_known if defined?(@work_location_known)
        @work_location_known = referral&.work_location_known
      end

      def work_location_known=(value)
        @work_location_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(work_location_known:)
      end

      def slug
        "teacher_role_work_location_known"
      end
    end
  end
end
