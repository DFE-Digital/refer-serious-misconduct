module PublicReferrals
  module Referrer
    class NameController < Referrals::Referrer::NameController
      private

      def next_path
        [:edit, current_referral.routing_scope, current_referral, :referrer, :phone]
      end

      def previous_path
        public_referral_personal_details_path(current_referral)
      end
    end
  end
end
