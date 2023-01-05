module PublicReferrals
  class ReferrerPhoneController < Referrals::ReferrerPhoneController
    def next_path
      public_referral_referrer_path(current_referral)
    end

    def update_path
      public_referral_referrer_phone_path(current_referral)
    end
  end
end
