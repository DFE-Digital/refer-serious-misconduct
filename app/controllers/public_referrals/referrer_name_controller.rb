module PublicReferrals
  class ReferrerNameController < Referrals::ReferrerNameController
    private

    def next_path
      edit_public_referral_referrer_phone_path(current_referral)
    end

    def update_path
      public_referral_referrer_name_path(current_referral)
    end
  end
end
