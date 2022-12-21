# frozen_string_literal: true
module Referrals
  module TeacherRole
    class TeachingLocationKnownForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :teaching_location_known

      validates :referral, presence: true
      validates :teaching_location_known, inclusion: { in: [true, false] }

      def teaching_location_known=(value)
        @teaching_location_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(teaching_location_known:)
      end
    end
  end
end
