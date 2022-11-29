module Referrals
  class ReferrerPhoneController < Referrals::BaseController
    def edit
      @referrer_phone_form = ReferrerPhoneForm.new(referral: current_referral)
    end

    def update
      @referrer_phone_form =
        ReferrerPhoneForm.new(
          referrer_phone_form_params.merge(referral: current_referral)
        )
      if @referrer_phone_form.save
        redirect_to next_page
      else
        render :edit
      end
    end

    private

    def referrer_phone_form_params
      params.require(:referrer_phone_form).permit(:phone)
    end

    def next_path
      referral_referrer_path(current_referral)
    end
  end
end
