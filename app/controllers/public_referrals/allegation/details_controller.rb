# frozen_string_literal: true

module PublicReferrals
  module Allegation
    class DetailsController < Referrals::Allegation::DetailsController
      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :allegation,
          :considerations
        ]
      end
    end
  end
end
