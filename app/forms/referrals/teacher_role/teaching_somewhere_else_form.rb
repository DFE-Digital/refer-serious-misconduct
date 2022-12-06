# frozen_string_literal: true
module Referrals
  module TeacherRole
    class TeachingSomewhereElseForm
      include ActiveModel::Model

      attr_accessor :referral, :teaching_somewhere_else

      validates :referral, presence: true
      validates :teaching_somewhere_else,
                inclusion: {
                  in: %w[yes no dont_know]
                }

      def save
        return false if invalid?

        referral.update(teaching_somewhere_else:)
      end
    end
  end
end
