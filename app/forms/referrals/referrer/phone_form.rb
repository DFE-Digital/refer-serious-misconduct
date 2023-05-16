module Referrals
  module Referrer
    class PhoneForm < FormItem
      attr_referrer :phone

      validates :phone,
                format: {
                  with: /\A(\+44\s?)?(?:\d\s?){10,11}\z/,
                  if: -> { phone&.present? }
                },
                presence: true

      def slug
        "referrer_phone"
      end

      def save
        return false unless valid?

        referrer.update(phone:)
      end

      def referrer
        @referrer ||= referral&.referrer || referral&.build_referrer
      end
    end
  end
end
