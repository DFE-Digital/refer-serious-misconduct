class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_or_initialize_by(sign_in_params)

    if resource.save
      secret_key = ROTP::Base32.random
      resource.update(secret_key:)
      # TODO: send otp via email
      redirect_to new_user_otp_path(id: resource.id)
    else
      render :new
    end
  end

  private

  def sign_in_params
    resource_params.permit(:email)
  end
end
