module Referrals
  class BaseController < ApplicationController
    include AuthenticateUser
    include StoreUserLocation
    include RedirectIfFeatureFlagInactive
    include RedirectIfReferralSubmitted

    before_action { redirect_if_feature_flag_inactive(:referral_form) }

    def edit
    end

    private

    def current_referral
      id = params[:id] || params[:referral_id] || params[:public_referral_id]

      return nil if id.blank?

      @current_referral ||= current_user.referrals.find(id)
    end
    helper_method :current_referral

    def next_page
      next_path
    end

    # Overwrite this method with the path of the next page in the journey
    def next_path
      root_path
    end
  end
end
