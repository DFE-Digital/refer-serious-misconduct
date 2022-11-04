module Referrals
  class ReferrerPhoneController < ApplicationController
    def edit
      @referrer_phone_form = ReferrerPhoneForm.new(referral: current_referral)
    end

    def update
      @referrer_phone_form =
        ReferrerPhoneForm.new(
          referrer_phone_form_params.merge(referral: current_referral)
        )
      if @referrer_phone_form.save
        redirect_to referral_referrer_details_path(current_referral)
      else
        render :edit
      end
    end

    private

    def current_referral
      @current_referral ||= Referral.find(params[:referral_id])
    end
    helper_method :current_referral

    def referrer_phone_form_params
      params.require(:referrer_phone_form).permit(:phone)
    end
  end
end
