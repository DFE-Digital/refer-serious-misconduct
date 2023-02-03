module PublicReferrals
  class ReviewController < Referrals::ReviewController
    private

    def referral
      @referral ||=
        current_user.referrals.member_of_public.find(
          params[:public_referral_id]
        )
    end
  end
end
