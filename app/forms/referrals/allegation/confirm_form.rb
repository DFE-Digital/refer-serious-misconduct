# frozen_string_literal: true
module Referrals
  module Allegation
    class ConfirmForm
      include ActiveModel::Model

      validates :allegation_details_complete, inclusion: { in: [true, false] }

      attr_accessor :referral
      attr_reader :allegation_details_complete

      def allegation_details_complete=(value)
        @allegation_details_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        referral.update(allegation_details_complete:) if valid?
      end
    end
  end
end
