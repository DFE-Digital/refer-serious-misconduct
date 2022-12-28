# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class QtsForm
      include ActiveModel::Model

      attr_accessor :referral, :has_qts

      validates :has_qts, inclusion: { in: %w[yes no not_sure] }

      def save
        referral.update(has_qts:) if valid?
      end
    end
  end
end
