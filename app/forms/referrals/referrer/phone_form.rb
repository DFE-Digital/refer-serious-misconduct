module Referrals
  module Referrer
    class PhoneForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_writer :phone

      validates :referral, presence: true
      validates :phone,
                format: {
                  with: /\A(\+44\s?)?(?:\d\s?){10,11}\z/,
                  if: -> { phone&.present? }
                },
                presence: true

      def phone
        @phone ||= referrer&.phone
      end

      def save
        return false unless valid?

        referrer.update(phone:)
      end

      delegate :referrer, to: :referral, allow_nil: true
    end
  end
end
