class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = resource_class.find_or_initialize_by(sign_in_params)

    if resource.save
      resource.create_otp
      UserMailer.otp(resource).deliver_later

      redirect_to new_user_otp_path(uuid: resource.uuid, new_referral:)
    else
      render :new
    end
  end

  private

  def sign_in_params
    resource_params.permit(:email)
  end

  def new_referral
    params[:new_referral] == "true"
  end
  alias_method :new_referral?, :new_referral
  helper_method :new_referral, :new_referral?
end
