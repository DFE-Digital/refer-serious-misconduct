# frozen_string_literal: true
module Referrals
  module TeacherRole
    class OrganisationAddressKnownForm
      include ReferralFormSection

      attr_referral :organisation_address_known

      validates :organisation_address_known, inclusion: { in: [true, false] }

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
