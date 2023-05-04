# frozen_string_literal: true
module Referrals
  module Allegation
    class DbsForm
      include ReferralFormSection

      validates :dbs_notified, inclusion: { in: [true, false] }

      attr_referral :dbs_notified

      def save
        return false if invalid?

        referral.update(dbs_notified:)
        true
      end
    end
  end
end
