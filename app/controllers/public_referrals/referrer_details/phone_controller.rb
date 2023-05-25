module PublicReferrals
  module ReferrerDetails
    class PhoneController < Referrals::ReferrerDetails::PhoneController
      def previous_path
        polymorphic_path(
          [:edit, current_referral.routing_scope, current_referral, :referrer_details, :name]
        )
      end
    end
  end
end
