class Users::OtpController < DeviseController
  include ReferralPaths

  prepend_before_action :require_no_authentication, only: %i[new create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action(only: [:create]) do
    request.env["devise.skip_timeout"] = true
  end

  def new
    @otp_form = Users::OtpForm.new(uuid: params[:uuid])
  end

  def create
    @otp_form = Users::OtpForm.new(user_params)

    if @otp_form.otp_expired? || !@otp_form.secret_key?
      fail_and_retry(reason: :expired)
    elsif @otp_form.valid?
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:success, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to after_sign_in_path_for(resource)
      resource.after_successful_otp_authentication
    elsif @otp_form.maximum_guesses?
      fail_and_retry(reason: :exhausted)
    else
      render :new
    end
  end

  def retry
    @error = params[:error]
  end

  protected

  def fail_and_retry(reason:)
    @otp_form.user.after_failed_otp_authentication
    redirect_to retry_user_sign_in_path(error: reason)
  end

  def auth_options
    mapping = Devise.mappings[resource_name]
    { scope: resource_name, recall: "#{mapping.path.pluralize}/sessions#new" }
  end

  def translation_scope
    "devise.sessions"
  end

  private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || latest_referral_path(resource)
  end

  def latest_referral_path(resource)
    latest_referral = resource.latest_referral

    latest_referral ? edit_path_for(latest_referral) : who_path
  end

  def user_params
    params.require(:user).permit(:uuid, :otp, :email)
  end
end
