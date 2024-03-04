module AdminInterface
  class AdminInterfaceController < ApplicationController
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :staff_user_not_authorized

    layout "support_layout"

    before_action :authenticate_staff!, :authorize_admin

    private

    def staff_user_not_authorized
      redirect_to forbidden_path
    end

    def authorize_admin
      authorize :admin
    end

    alias_method :pundit_user, :current_staff
  end
end
