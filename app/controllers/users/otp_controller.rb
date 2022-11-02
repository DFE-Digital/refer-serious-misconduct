class Users::OtpController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action(only: [:create]) { request.env["devise.skip_timeout"] = true }

  def new
    self.resource = resource_class.find(params[:id])

    ### TODO - remove these lines, for testing/debugging only
    if HostingEnvironment.test_environment?
      otp_generator = ROTP::HOTP.new(resource.secret_key)
      @derived_otp = otp_generator.at(0)
    end
    ###
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to after_sign_in_path_for(resource)
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

  def after_sign_in_path_for(_resource)
    root_path
  end
end
