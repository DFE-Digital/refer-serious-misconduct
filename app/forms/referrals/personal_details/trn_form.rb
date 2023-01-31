# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class TrnForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :trn, :trn_known

      validates :trn_known, inclusion: { in: [true, false] }
      validates :trn, presence: true, length: { is: 7 }, if: -> { trn_known }

      def trn=(value)
        @trn = value&.delete("^0-9")
      end

      def trn_known=(value)
        @trn_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        referral.update(trn_known:, trn: trn_known ? trn : nil) if valid?
      end
    end
  end
end
