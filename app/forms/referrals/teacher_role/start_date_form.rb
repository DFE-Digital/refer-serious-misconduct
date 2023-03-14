# frozen_string_literal: true
module Referrals
  module TeacherRole
    class StartDateForm
      include ReferralFormSection

      attr_accessor :date_params, :role_start_date
      attr_reader :role_start_date_known

      validates :role_start_date_known, inclusion: { in: [true, false] }
      validates :role_start_date,
                date: {
                  not_future: true,
                  past_century: true
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
