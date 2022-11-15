class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_or_initialize_by(sign_in_params)

    if resource.save
      secret_key = Devise::Otp.generate_key
      resource.update(secret_key:)
      if FeatureFlags::FeatureFlag.active?(:otp_emails)
        UserMailer.send_otp(resource).deliver_later
      end
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
