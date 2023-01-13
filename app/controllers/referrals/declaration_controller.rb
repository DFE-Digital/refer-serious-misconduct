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
        redirect_to next_path
      else
        render :show
      end
    end

    private

    def declaration_form_params
      params.require(:declaration_form).permit(:declaration_agreed)
    end

    def update_path
      referral_declaration_path(current_referral)
    end
    helper_method :update_path

    def back_link
      referral_review_path(current_referral)
    end
    helper_method :back_link

    def next_path
      referral_confirmation_path(current_referral)
    end
  end
end
