# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EndDateForm
      include ReferralFormSection

      attr_accessor :date_params, :referral
      attr_writer :role_end_date
      attr_referral :role_end_date_known, :role_end_date

      validates :role_end_date_known, inclusion: { in: [true, false] }
      validates :role_end_date,
                date: {
                  not_future: false,
                  past_century: true
                },
                if: -> { role_end_date_known }

      def role_end_date_known=(value)
        @role_end_date_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(role_end_date:, role_end_date_known:)
      end
    end
  end
end
