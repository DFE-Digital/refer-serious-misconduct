module Referrals
  module ContactDetails
    class EmailForm
      include ReferralFormSection

      attr_writer :email_address

      validates :email_known, inclusion: { in: [true, false] }
      validates :email_address, presence: true, length: { maximum: 256 }, if: -> { email_known }
      validates :email_address,
                valid_for_notify: true,
                if: -> { email_known && email_address.present? }

      def email_known
        return @email_known if defined?(@email_known)
        @email_known = referral&.email_known
      end

      def email_known=(value)
        @email_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def email_address
        @email_address ||= referral&.email_address
      end

      def save
        return false unless valid?

        referral.email_known = email_known
        referral.email_address = email_known ? email_address : nil
        referral.save
      end

      def slug
        "contact_details_email"
      end
    end
  end
end
