module Referrals
  class BaseController < ApplicationController
    include AuthenticateUser
    include StoreUserLocation
    include RedirectIfFeatureFlagInactive

    before_action { redirect_if_feature_flag_inactive(:referral_form) }
    before_action :set_return_to_url, only: :edit

    def edit
    end

    private

    def current_referral
      @current_referral ||= current_user.referrals.find(params[:referral_id])
    end
    helper_method :current_referral

    def set_return_to_url
      session[:return_to] = params["return_to"]
    end

    def next_page
      session.delete(:return_to) || next_path
    end

    # Overwrite this method with the path of the next page in the journey
    def next_path
      root_path
    end
  end
end
