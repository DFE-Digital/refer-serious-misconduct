module Referrals
  module Referrer
    class NameForm
      include ReferralFormSection

      attr_writer :first_name, :last_name

      validates :first_name, presence: true
      validates :last_name, presence: true

      def slug
        "referrer_name"
      end

      def first_name
        @first_name ||= referrer&.first_name
      end

      def last_name
        @last_name ||= referrer&.last_name
      end

      def save
        return false unless valid?

        referrer.update(first_name:, last_name:)
      end

      private

      def referrer
        @referrer ||= referral&.referrer || referral&.build_referrer
      end
    end
  end
end
