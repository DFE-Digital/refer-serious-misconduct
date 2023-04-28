module Referrals
  module Organisation
    class AddressForm
      include ReferralFormSection

      attr_writer :name, :street_1, :street_2, :city, :postcode
      attr_organisation :name, :street_1, :street_2, :city, :postcode

      validates :name, presence: true
      validates :street_1, presence: true
      validates :city, presence: true
      validates :postcode, presence: true

      validate :postcode_is_valid, if: -> { postcode.present? }

      def slug
        "organisation_address"
      end

      def organisation
        @organisation ||= referral&.organisation || referral&.build_organisation
      end

      def save
        return false unless valid?

        organisation.update(city:, name:, postcode:, street_1:, street_2:)
      end

      private

      def postcode_is_valid
        return if UKPostcode.parse(postcode).full_valid?

        errors.add(:postcode, :invalid)
      end
    end
  end
end
