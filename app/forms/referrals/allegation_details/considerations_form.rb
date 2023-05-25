# frozen_string_literal: true
module Referrals
  module AllegationDetails
    class ConsiderationsForm < FormItem
      validates :allegation_consideration_details, presence: true

      attr_referral :allegation_consideration_details

      def save
        return false if invalid?

        referral.update(allegation_consideration_details:)
      end
    end
  end
end
