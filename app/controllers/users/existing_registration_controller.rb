class Users::ExistingRegistrationController < ApplicationController
  def new
    @registration_exists_form = RegistrationExistsForm.new
  end

  def create
    @registration_exists_form =
      RegistrationExistsForm.new(registration_exists_form_params)

    if @registration_exists_form.valid?
      if @registration_exists_form.registration_exists?
        redirect_to new_user_session_path
      else
        redirect_to referral_type_path
      end
    else
      render :new
    end
  end

  private

  def registration_exists_form_params
    params.require(:registration_exists_form).permit(:registration_exists)
  end
end
