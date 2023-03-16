module PublicReferrals
  module Referrer
    class PhoneController < Referrals::Referrer::PhoneController
      def previous_path
        polymorphic_path([:edit, current_referral.routing_scope, current_referral, :referrer, :check_answers])
      end
    end
  end
end
