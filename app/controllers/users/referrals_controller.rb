module Users
  class ReferralsController < ApplicationController
    include AuthenticateUser
    include StoreUserLocation

    def index
      @referrals_submitted = current_user.referrals.submitted.order(submitted_at: :desc)
      @referral_in_progress = current_user.referral_in_progress
    end

    def show
      @referral_form = ReferralForm.new(referral: current_referral)

      redirect_to :not_found unless current_referral.submitted?
    end

    def current_referral
      @current_referral ||= current_user.referrals.find(params[:id])
    end
    helper_method :current_referral
  end
end
