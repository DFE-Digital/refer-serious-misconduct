# frozen_string_literal: true

class PublicReferralsController < ReferralsController
  def new
    super
    @create_path = public_referrals_path
  end
end
