# frozen_string_literal: true
module Referrals
  module TeacherRole
    class OrganisationAddressKnownForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :organisation_address_known

      validates :referral, presence: true
      validates :organisation_address_known, inclusion: { in: [true, false] }

      def organisation_address_known=(value)
        @organisation_address_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(organisation_address_known:)
      end
    end
  end
end
