class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = find_or_initialize_user

    if resource.save
      resource.create_otp
      UserMailer.otp(resource).deliver_later

      redirect_to new_user_otp_path(uuid: resource.uuid, new_referral:)
    else
      render :new
    end
  end

  private

  # Without an email the lookup has no conditions and would match the first
  # user, so a blank email builds a record that fails validation instead.
  def find_or_initialize_user
    return resource_class.new(sign_in_params) if sign_in_params[:email].blank?

    resource_class.find_for_authentication(sign_in_params) || resource_class.new(sign_in_params)
  end

  def sign_in_params
    resource_params.permit(:email)
  end

  def new_referral
    params[:new_referral] == "true"
  end
  alias_method :new_referral?, :new_referral
  helper_method :new_referral, :new_referral?
end
