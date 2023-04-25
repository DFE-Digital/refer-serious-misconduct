# frozen_string_literal: true
module Referrals
  module TeacherRole
    class OrganisationAddressForm
      include ReferralFormSection

      attr_writer :organisation_name,
                  :organisation_address_line_1,
                  :organisation_address_line_2,
                  :organisation_town_or_city,
                  :organisation_postcode

      validates :organisation_name,
                :organisation_address_line_1,
                :organisation_town_or_city,
                :organisation_postcode,
                presence: true
      validate :postcode_is_valid, if: -> { organisation_postcode.present? }

      def organisation_name
        @organisation_name ||= referral&.organisation_name
      end

      def organisation_address_line_1
        @organisation_address_line_1 ||= referral&.organisation_address_line_1
      end

      def organisation_address_line_2
        @organisation_address_line_2 ||= referral&.organisation_address_line_2
      end

      def organisation_town_or_city
        @organisation_town_or_city ||= referral&.organisation_town_or_city
      end

      def organisation_postcode
        @organisation_postcode ||= referral&.organisation_postcode
      end

      def save
        return false if invalid?

        referral.update(
          organisation_name:,
          organisation_address_line_1:,
          organisation_address_line_2:,
          organisation_town_or_city:,
          organisation_postcode:
        )
      end

      def slug
        "teacher_role_organisation_address"
      end

      private

      def postcode_is_valid
        unless UKPostcode.parse(organisation_postcode).full_valid?
          errors.add(:organisation_postcode, :invalid)
        end
      end
    end
  end
end
