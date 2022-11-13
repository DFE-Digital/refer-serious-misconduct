module Referrals
  class BaseController < ApplicationController
    before_action :store_user_location!, if: :storable_location?
    before_action :authenticate_user!,
                  if: -> { FeatureFlags::FeatureFlag.active?(:user_accounts) }
    before_action :redirect_if_feature_flag_disabled

    private

    def current_referral
      @current_referral ||= current_user.referrals.find(params[:referral_id])
    end
    helper_method :current_referral

    def redirect_if_feature_flag_disabled
      return if FeatureFlags::FeatureFlag.active?(:employer_form)

      redirect_to start_path && return
    end

    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? &&
        !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end
  end
end
