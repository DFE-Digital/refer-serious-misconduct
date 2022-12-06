module Referrals
  class BaseController < ApplicationController
    before_action :store_user_location!, if: :storable_location?
    before_action :authenticate_user!,
                  if: -> { FeatureFlags::FeatureFlag.active?(:user_accounts) }
    before_action :redirect_if_feature_flag_disabled
    before_action :redirect_referrals_requests_if_user_accounts_disabled
    before_action :set_return_to_url, only: :edit

    def edit
    end

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

    def redirect_referrals_requests_if_user_accounts_disabled
      return if request.path !~ %r{^/referral}
      return if FeatureFlags::FeatureFlag.active?(:user_accounts)

      redirect_to root_path
    end

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
