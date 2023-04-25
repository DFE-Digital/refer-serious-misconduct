# frozen_string_literal: true
module Referrals
  module Allegation
    class DbsForm
      include ReferralFormSection

      validates :dbs_notified, inclusion: { in: [true, false] }

      def dbs_notified
        return @dbs_notified if defined?(@dbs_notified)
        @dbs_notified = referral&.dbs_notified
      end

      def dbs_notified=(value)
        @dbs_notified = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(dbs_notified:)
        true
      end

      def slug
        "allegation_dbs"
      end
    end
  end
end
