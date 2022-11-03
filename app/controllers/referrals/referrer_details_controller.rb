module Referrals
  class ReferrerDetailsController < ApplicationController
    def show
      @referrer = current_referral.referrer
    end

    private

    def current_referral
      @current_referral ||= Referral.find(params[:referral_id])
    end
    helper_method :current_referral
  end
end
