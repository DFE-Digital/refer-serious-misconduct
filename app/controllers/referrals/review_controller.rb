module Referrals
  class ReviewController < BaseController
    def show
      @allegation_confirm_form =
        Referrals::Allegation::ConfirmForm.new(referral: current_referral)
      @organisation = current_referral.organisation
      @referrer = current_referral.referrer
    end
  end
end
