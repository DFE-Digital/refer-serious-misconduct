# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EndDateForm < FormItem
      attr_accessor :date_params, :referral
      attr_referral :role_end_date_known, :role_end_date

      validates :role_end_date_known, inclusion: { in: [true, false] }
      validates :role_end_date,
                date: {
                  not_future: false,
                  past_century: true
                },
                if: -> { role_end_date_known }

      def save
        return false if invalid?

        referral.update(role_end_date:, role_end_date_known:)
      end
    end
  end
end
