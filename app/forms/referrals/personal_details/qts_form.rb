# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class QtsForm
      include ActiveModel::Model

      attr_accessor :referral, :has_qts

      validates :has_qts, inclusion: { in: %w[yes no dont_know] }

      def save
        referral.update(has_qts:) if valid?
      end
    end
  end
end
