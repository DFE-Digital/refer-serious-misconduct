# frozen_string_literal: true
module Referrals
  module Allegation
    class ConsiderationsForm
      include ActiveModel::Model

      validates :consideration_details, presence: true

      attr_accessor :referral, :allegation_consideration_details

      def save
        return false if invalid?

        referral.update(allegation_consideration_details:)
      end
    end
  end
end
