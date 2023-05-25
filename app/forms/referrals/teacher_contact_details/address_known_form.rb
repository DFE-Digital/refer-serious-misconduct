module Referrals
  module TeacherContactDetails
    class AddressKnownForm < FormItem
      attr_referral :address_known

      validates :address_known, inclusion: { in: [true, false] }

      def save
        return false unless valid?

        referral.update(address_known:)
      end
    end
  end
end
