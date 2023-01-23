module Referrals
  module ContactDetails
    class EmailForm
      include ActiveModel::Model

      attr_accessor :referral, :email_address
      attr_reader :email_known

      validates :referral, presence: true
      validates :email_known, inclusion: { in: [true, false] }
      validates :email_address,
                presence: true,
                length: {
                  maximum: 256
                },
                if: -> { email_known }
      validates :email_address,
                valid_for_notify: true,
                if: -> { email_known && email_address.present? }

      def email_known=(value)
        @email_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.email_known = email_known
        referral.email_address = email_known ? email_address : nil
        referral.save
      end
    end
  end
end
