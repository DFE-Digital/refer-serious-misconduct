module Referrals
  module ContactDetails
    class AddressKnownForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :address_known

      validates :referral, presence: true
      validates :address_known, inclusion: { in: [true, false] }

      def address_known=(value)
        @address_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(address_known:)
      end
    end
  end
end
