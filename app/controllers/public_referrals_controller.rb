# frozen_string_literal: true

class PublicReferralsController < ReferralsController
  def new
    super
    @create_path = public_referrals_path
  end

  private

  def referral
    @referral ||= current_user.referrals.member_of_public.find(params[:id])
  end
end
