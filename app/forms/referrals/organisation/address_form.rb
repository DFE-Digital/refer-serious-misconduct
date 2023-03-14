module Referrals
  module Organisation
    class AddressForm
      include ReferralFormSection

      attr_writer :name, :street_1, :street_2, :city, :postcode

      validates :name, presence: true
      validates :street_1, presence: true
      validates :city, presence: true
      validates :postcode, presence: true

      validate :postcode_is_valid, if: -> { postcode.present? }

      def city
        @city ||= organisation&.city
      end

      def name
        @name ||= organisation&.name
      end

      def organisation
        @organisation ||= referral&.organisation || referral&.build_organisation
      end

      def postcode
        @postcode ||= organisation&.postcode
      end

      def street_1
        @street_1 ||= organisation&.street_1
      end

      def street_2
        @street_2 ||= organisation&.street_2
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
