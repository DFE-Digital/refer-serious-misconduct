# frozen_string_literal: true
module ManageInterface
  class ManageInterfaceController < ApplicationController
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :staff_user_not_authorized

    layout "support_layout"

    before_action :authenticate_staff!, :authorize_management

    def authorize_management
      authorize :management
    end

    def staff_user_not_authorized
      redirect_to forbidden_path
    end

    alias_method :pundit_user, :current_staff
  end
end
