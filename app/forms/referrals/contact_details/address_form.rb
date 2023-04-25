module Referrals
  module ContactDetails
    class AddressForm
      include ReferralFormSection

      attr_writer :address_line_1, :address_line_2, :town_or_city, :postcode, :country

      validates :address_line_1, :town_or_city, :postcode, presence: true
      validate :postcode_is_valid, if: -> { postcode.present? }

      def address_line_1
        @address_line_1 ||= referral&.address_line_1
      end

      def address_line_2
        @address_line_2 ||= referral&.address_line_2
      end

      def town_or_city
        @town_or_city ||= referral&.town_or_city
      end

      def postcode
        @postcode ||= referral&.postcode
      end

      def country
        @country ||= referral&.country
      end

      def save
        return false unless valid?

        referral.update(address_line_1:, address_line_2:, town_or_city:, postcode:, country:)
      end

      private

      def postcode_is_valid
        return if UKPostcode.parse(postcode).full_valid?

        errors.add(:postcode, :invalid)
      end

      def slug
        "contact_details_address"
      end
    end
  end
end
