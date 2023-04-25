# frozen_string_literal: true
module Referrals
  module TeacherRole
    class SameOrganisationForm
      include ReferralFormSection

      validates :same_organisation, inclusion: { in: [true, false] }

      def same_organisation
        return @same_organisation if defined?(@same_organisation)
        @same_organisation = referral&.same_organisation
      end

      def same_organisation=(value)
        @same_organisation = ActiveModel::Type::Boolean.new.cast(value)
      end

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
