module Referrals
  class BaseController < ApplicationController
    before_action :authenticate_user!,
                  if: -> { FeatureFlags::FeatureFlag.active?(:user_accounts) }
    before_action :redirect_if_feature_flag_disabled

    private

    def current_referral
      @current_referral ||=
        if FeatureFlags::FeatureFlag.active?(:user_accounts)
          current_user.referrals.find(params[:referral_id])
        else
          Referral.find(params[:referral_id])
        end
    end
    helper_method :current_referral

    def redirect_if_feature_flag_disabled
      return if FeatureFlags::FeatureFlag.active?(:employer_form)

      redirect_to start_path && return
    end
  end
end
