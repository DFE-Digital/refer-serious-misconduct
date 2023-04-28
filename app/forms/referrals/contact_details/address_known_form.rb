module Referrals
  module ContactDetails
    class AddressKnownForm
      include ReferralFormSection

      attr_referral :address_known

      validates :address_known, inclusion: { in: [true, false] }

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
