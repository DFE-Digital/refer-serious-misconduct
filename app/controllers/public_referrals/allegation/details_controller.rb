# frozen_string_literal: true

module PublicReferrals
  module Allegation
    class DetailsController < Referrals::Allegation::DetailsController
      def next_path
        edit_public_referral_allegation_considerations_path(current_referral)
      end

      def update_path
        public_referral_allegation_details_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_public_referral_path(current_referral)
      end
      helper_method :back_link
    end
  end
end
