module Referrals
  class ReferrerNameController < ApplicationController
    def edit
      @referrer_name_form =
        Referrals::ReferrerNameForm.new(referral: current_referral)
    end

    def update
      @referrer_name_form =
        Referrals::ReferrerNameForm.new(
          name_params.merge(referral: current_referral)
        )
      if @referrer_name_form.save
        current_referral.referrer.update!(name: @referrer_name_form.name)
        redirect_to referral_referrer_details_path(current_referral)
      else
        render :edit
      end
    end

    private

    def current_referral
      Referral.find(params[:referral_id])
    end
    helper_method :current_referral

    def name_params
      params.require(:referrals_referrer_name_form).permit(:name)
    end
  end
end
