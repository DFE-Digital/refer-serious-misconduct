module PublicReferrals
  class ReferrersController < Referrals::ReferrersController
    def next_path
      edit_public_referral_path(current_referral)
    end

    def update_path
      public_referral_referrer_path(current_referral)
    end
  end
end
