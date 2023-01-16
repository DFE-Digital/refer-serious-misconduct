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

    def previous_path
      polymorphic_path(
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :referrer_job_title
        ]
      )
    end
    helper_method :previous_path

    def update_path
      referral_referrer_phone_path(current_referral)
    end
    helper_method :update_path
  end
end
