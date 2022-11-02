# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class TrnForm
      include ActiveModel::Model

      attr_accessor :trn_known, :referral
      attr_reader :trn

      validates :trn_known, inclusion: { in: %w[true false] }
      validates :trn,
                presence: true,
                length: {
                  is: 7
                },
                if: -> { trn_known == "true" }

      def trn=(value)
        @trn = value&.delete("^0-9")
      end

      def save
        referral.update!(trn_known:, trn:) if valid?
      end
    end
  end
end
