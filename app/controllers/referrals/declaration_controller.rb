module Referrals
  class DeclarationController < BaseController
    def show
      @declaration_form = DeclarationForm.new(referral: current_referral)
    end

    def create
      @declaration_form =
        DeclarationForm.new(
          declaration_form_params.merge(referral: current_referral)
        )
      if @declaration_form.save
        redirect_to referral_confirmation_path(current_referral)
      else
        render :show
      end
    end

    private

    def declaration_form_params
      params.require(:declaration_form).permit(:declaration_agreed)
    end
  end
end
