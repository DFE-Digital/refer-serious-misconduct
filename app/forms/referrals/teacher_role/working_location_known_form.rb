# frozen_string_literal: true
module Referrals
  module TeacherRole
    class WorkingLocationKnownForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :working_location_known

      validates :referral, presence: true
      validates :working_location_known, inclusion: { in: [true, false] }

      def working_location_known=(value)
        @working_location_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(working_location_known:)
      end
    end
  end
end
