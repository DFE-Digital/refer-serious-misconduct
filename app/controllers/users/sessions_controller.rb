class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_or_initialize_by(sign_in_params)

    if resource.save
      resource.create_otp
      UserMailer.send_otp(resource).deliver_later

      redirect_to new_user_otp_path(uuid: resource.uuid)
    else
      render :new
    end
  end

  private

  def sign_in_params
    resource_params.permit(:email)
  end
end
