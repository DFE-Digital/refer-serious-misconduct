# frozen_string_literal: true
module Referrals
  module TeacherRole
    class StartDateForm
      include ActiveModel::Model

      attr_accessor :date_params, :referral, :role_start_date
      attr_reader :role_start_date_known

      validates :referral, presence: true
      validates :role_start_date_known, inclusion: { in: [true, false] }
      validates :role_start_date,
                date: {
                  in_the_future: false
                },
                if: -> { role_start_date_known }

      def role_start_date_known=(value)
        @role_start_date_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(role_start_date:, role_start_date_known:)
      end
    end
  end
end
