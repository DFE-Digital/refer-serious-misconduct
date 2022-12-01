# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EmploymentStatusForm
      include ActiveModel::Model

      attr_accessor :date_params,
                    :referral,
                    :role_end_date,
                    :employment_status,
                    :reason_leaving_role

      validates :referral, presence: true
      validates :employment_status,
                inclusion: {
                  in: %w[employed suspended left_role]
                }
      validates :reason_leaving_role,
                inclusion: {
                  in: %w[resigned dismissed retired unknown]
                },
                if: :left_role?
      validates :role_end_date, date: { required: false }, if: :left_role?

      def save
        return false if invalid?

        referral.update(
          employment_status:,
          role_end_date:,
          reason_leaving_role:
        )
      end

      private

      def left_role?
        employment_status == "left_role"
      end
    end
  end
end
