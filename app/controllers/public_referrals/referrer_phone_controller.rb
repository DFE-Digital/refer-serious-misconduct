module PublicReferrals
  class ReferrerPhoneController < Referrals::ReferrerPhoneController
    def previous_path
      polymorphic_path(
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :referrer_name
        ]
      )
    end
  end
end
