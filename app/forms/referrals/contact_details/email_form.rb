module Referrals
  module ContactDetails
    class EmailForm
      include ReferralFormSection

      attr_referral :email_known, :email_address

      validates :email_known, inclusion: { in: [true, false] }
      validates :email_address, presence: true, length: { maximum: 256 }, if: -> { email_known }
      validates :email_address,
                valid_for_notify: true,
                if: -> { email_known && email_address.present? }

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
