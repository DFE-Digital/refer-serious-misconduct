# frozen_string_literal: true

class Staff::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  skip_before_action :require_no_authentication, only: %i[new]
  before_action :check_signed_in, only: %i[new]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    stored_location = stored_location_for(resource)

    if stored_location.present? && stored_location.exclude?(manage_sign_in_path)
      return URI.parse(stored_location).path
    end

    if current_staff.manage_referrals?
      manage_interface_referrals_path
    elsif current_staff.view_support?
      support_interface_staff_index_path
    else
      flash[:warning] = I18n.t("pundit.unauthorized")
      root_path
    end
  end

  def after_sign_out_path_for(_resource)
    manage_sign_in_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def check_signed_in
    return unless staff_signed_in?

    redirect_to after_sign_in_path_for(current_staff)
  end
end
