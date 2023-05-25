module Referrals
  module TeacherContactDetails
    class TelephoneForm < FormItem
      attr_referral :phone_known, :phone_number

      validates :phone_known, inclusion: { in: [true, false] }
      validates :phone_number, presence: true, if: -> { phone_known }
      validates :phone_number,
                format: {
                  with: /\A(\+44\s?)?(?:\d\s?){10,11}\z/
                },
                if: -> { phone_known && phone_number.present? }

      def save
        return false unless valid?

        referral.phone_known = phone_known
        referral.phone_number = phone_known ? phone_number : nil
        referral.save
      end
    end
  end
end
