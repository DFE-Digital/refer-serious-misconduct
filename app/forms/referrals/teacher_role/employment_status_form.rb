# frozen_string_literal: true
module Referrals
  module TeacherRole
    class EmploymentStatusForm
      include ActiveModel::Model

      attr_accessor :referral, :employment_status

      validates :referral, presence: true
      validates :employment_status,
                inclusion: {
                  in: %w[employed suspended left_role]
                }

      def save
        return false if invalid?

        referral.update(employment_status:)
      end
    end
  end
end
