# frozen_string_literal: true
module Referrals
  module TeacherRole
    class SameOrganisationForm < FormItem
      attr_referral :same_organisation

      validates :same_organisation, inclusion: { in: [true, false] }

      def save
        return false if invalid?

        referral.update(same_organisation:)
      end

      def slug
        "teacher_role_same_organisation"
      end
    end
  end
end
