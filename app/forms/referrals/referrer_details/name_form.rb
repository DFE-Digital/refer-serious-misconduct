module Referrals
  module ReferrerDetails
    class NameForm < FormItem
      attr_referrer :first_name, :last_name

      validates :first_name, presence: true
      validates :last_name, presence: true

      def save
        return false unless valid?

        referrer.update(first_name:, last_name:)
      end

      def referrer
        @referrer ||= referral&.referrer || referral&.build_referrer
      end
    end
  end
end
