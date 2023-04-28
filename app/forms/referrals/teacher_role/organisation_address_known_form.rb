# frozen_string_literal: true
module Referrals
  module TeacherRole
    class OrganisationAddressKnownForm
      include ReferralFormSection

      attr_referral :organisation_address_known

      validates :organisation_address_known, inclusion: { in: [true, false] }

      def organisation_address_known=(value)
        @organisation_address_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(organisation_address_known:)
      end

      def slug
        "teacher_role_organisation_address_known"
      end
    end
  end
end
