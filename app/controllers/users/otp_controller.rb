class Users::OtpController < DeviseController
  prepend_before_action :require_no_authentication, only: %i[new create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action(only: [:create]) do
    request.env["devise.skip_timeout"] = true
  end

  def new
    @otp_form = Users::OtpForm.new(id: params[:id])

    # TODO: Remove this block once emailed OTPs are implemented
    # For now this makes manual testing in test environments simpler
    if HostingEnvironment.test_environment? && @otp_form.user.secret_key
      otp_generator = ROTP::HOTP.new(@otp_form.user.secret_key)
      @derived_otp = otp_generator.at(0)
    end
  end

  def create
    @otp_form = Users::OtpForm.new(user_params)

    if @otp_form.otp_expired?
      @otp_form.user.after_failed_otp_authentication
      flash[:warning] = "Security code has expired. Try again."
      redirect_to new_user_session_path
    elsif @otp_form.valid?
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:success, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      redirect_to after_sign_in_path_for(resource)
      resource.after_successful_otp_authentication
    elsif @otp_form.maximum_guesses?
      @otp_form.user.after_failed_otp_authentication
      flash[:warning] = "Too many incorrect login attempts. Try again."
      redirect_to new_user_session_path
    else
      render :new
    end
  end

  protected

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

    latest_referral ? referral_path(latest_referral) : root_path
  end

  def user_params
    params.require(:user).permit(:id, :otp, :email)
  end
end
