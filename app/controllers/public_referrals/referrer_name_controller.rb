module PublicReferrals
  class ReferrerNameController < Referrals::ReferrerNameController
    private

    def next_path
      [:edit, current_referral.routing_scope, current_referral, :referrer_phone]
    end
  end
end
