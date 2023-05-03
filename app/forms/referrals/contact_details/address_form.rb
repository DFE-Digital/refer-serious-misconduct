module Referrals
  module ContactDetails
    class AddressForm
      include ReferralFormSection

      attr_referral :address_line_1, :address_line_2, :town_or_city, :postcode, :country

      validates :address_line_1, :town_or_city, :postcode, presence: true
      validate :postcode_is_valid, if: -> { postcode.present? }

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
