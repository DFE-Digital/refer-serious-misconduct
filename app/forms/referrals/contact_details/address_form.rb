module Referrals
  module ContactDetails
    class AddressForm
      include ActiveModel::Model

      attr_accessor :referral,
                    :address_line_1,
                    :address_line_2,
                    :town_or_city,
                    :postcode,
                    :country
      attr_reader :address_known

      validates :referral, presence: true
      validates :address_known, inclusion: { in: [true, false] }
      validates :address_line_1,
                :town_or_city,
                :postcode,
                presence: true,
                if: -> { address_known }
      validate :postcode_is_valid, if: -> { postcode.present? && address_known }

      def address_known=(value)
        @address_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        address_attrs = {
          address_known:,
          address_line_1: nil,
          address_line_2: nil,
          town_or_city: nil,
          postcode: nil,
          country: nil
        }

        if address_known
          address_attrs.merge!(
            address_line_1:,
            address_line_2:,
            town_or_city:,
            postcode:,
            country:
          )
        end
        referral.update(address_attrs)
      end

      private

      def postcode_is_valid
        unless UKPostcode.parse(postcode).full_valid?
          errors.add(:postcode, :invalid)
        end
      end
    end
  end
end
