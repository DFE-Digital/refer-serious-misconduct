# frozen_string_literal: true
module Referrals
  module TeacherRole
    class OrganisationAddressForm < FormItem
      attr_referral :organisation_name,
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

      private

      def postcode_is_valid
        unless UKPostcode.parse(organisation_postcode).full_valid?
          errors.add(:organisation_postcode, :invalid)
        end
      end
    end
  end
end
