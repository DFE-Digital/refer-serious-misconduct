# frozen_string_literal: true
module Referrals
  module Allegation
    class DbsForm
      include ActiveModel::Model

      validates :dbs_notified, inclusion: { in: [true, false] }

      attr_accessor :referral
      attr_reader :dbs_notified

      def dbs_notified=(value)
        @dbs_notified = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(dbs_notified:)
        true
      end
    end
  end
end
