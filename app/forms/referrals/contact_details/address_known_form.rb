module Referrals
  module ContactDetails
    class AddressKnownForm
      include ReferralFormSection

      validates :address_known, inclusion: { in: [true, false] }

      def address_known
        return @address_known if defined?(@address_known)
        @address_known = referral&.address_known
      end

      def address_known=(value)
        @address_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(address_known:)
      end

      def slug
        "contact_details_address_known"
      end
    end
  end
end
