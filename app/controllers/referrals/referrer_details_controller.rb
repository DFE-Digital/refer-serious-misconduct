module Referrals
  class ReferrerDetailsController < Referrals::BaseController
    def show
      @referrer = current_referral.referrer
    end
  end
end
