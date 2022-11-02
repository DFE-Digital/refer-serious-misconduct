class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_or_initialize_by(sign_in_params)

    if resource.save
      # generate secret and otp
      secret_key = ROTP::Base32.random
      # otp = ROTP::HOTP.new(secret_key).at(0)

      # save 32-bit key to model
      resource.update(secret_key:)

      # TODO: send otp via email

      # redirect to OTP controller
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
