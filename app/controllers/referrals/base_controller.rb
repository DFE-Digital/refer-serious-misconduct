module Referrals
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :redirect_if_feature_flag_disabled

    private

    def current_referral
      @current_referral ||= Referral.find(params[:referral_id])
    end
    helper_method :current_referral

    def redirect_if_feature_flag_disabled
      return if FeatureFlags::FeatureFlag.active?(:employer_form)

      redirect_to start_path && return
    end
  end
end
