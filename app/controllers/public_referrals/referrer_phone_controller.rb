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

    def next_path
      public_referral_referrer_path(current_referral)
    end

    def update_path
      public_referral_referrer_phone_path(current_referral)
    end
  end
end
