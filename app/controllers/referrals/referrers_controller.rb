module Referrals
  class ReferrersController < BaseController
    def show
      @referrer = current_referral.referrer
      @referrer_form = ReferrerForm.new(referrer: @referrer)
    end

    def update
      @referrer_form =
        ReferrerForm.new(
          complete: referrer_params[:complete],
          referrer: current_referral.referrer
        )

      if @referrer_form.save
        redirect_to edit_referral_path(current_referral)
      else
        @referrer = current_referral.referrer
        render :show
      end
    end

    private

    def referrer_params
      params.require(:referrer_form).permit(:complete)
    end
  end
end
