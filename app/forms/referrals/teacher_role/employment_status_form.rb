# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EmploymentStatusForm
      include ActiveModel::Model
      include ValidatedDate

      attr_accessor :referral,
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
                if: -> { left_role? }

      def save(date_params = {})
        return false if invalid?

        if date_has_values?(date_params) &&
             !validated_date(
               date_params:,
               attribute: :role_end_date,
               required: false
             )
          return false
        end

        referral.update(
          employment_status:,
          role_end_date:,
          reason_leaving_role:
        )
        true
      end

      private

      def left_role?
        employment_status == "left_role"
      end

      def date_has_values?(params)
        left_role? && params.values.compact_blank.any?
      end
    end
  end
end
