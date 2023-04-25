module Referrals
  module ContactDetails
    class TelephoneForm
      include ReferralFormSection

      attr_writer :phone_number

      validates :phone_known, inclusion: { in: [true, false] }
      validates :phone_number, presence: true, if: -> { phone_known }
      validates :phone_number,
                format: {
                  with: /\A(\+44\s?)?(?:\d\s?){10,11}\z/
                },
                if: -> { phone_known && phone_number.present? }

      def phone_known
        return @phone_known if defined?(@phone_known)
        @phone_known = referral&.phone_known
      end

      def phone_known=(value)
        @phone_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def phone_number
        @phone_number ||= referral&.phone_number
      end

      def save
        return false unless valid?

        referral.phone_known = phone_known
        referral.phone_number = phone_known ? phone_number : nil
        referral.save
      end

      def slug
        "contact_details_telephone"
      end
    end
  end
end
