# frozen_string_literal: true
module SupportInterface
  class SupportInterfaceController < ApplicationController
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :staff_user_not_authorized

    layout "support_layout"

    before_action :authenticate_staff!, :authorize_support

    private

    def staff_user_not_authorized
      # FeatureFlags::Engine is a mounted engine and we can't control the
      # behaviour from this level. Attempting to do the redirect
      # here ends up in multiple redirects.
      unless is_a?(FeatureFlags::FeatureFlagsController)
        redirect_to forbidden_path
      end
    end

    def authorize_support
      authorize :support
    end

    alias_method :pundit_user, :current_staff
  end
end
