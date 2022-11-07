module Referrals
  class ReferrerNameController < Referrals::BaseController
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
        redirect_to edit_referral_referrer_job_title_path(current_referral)
      else
        render :edit
      end
    end

    private

    def name_params
      params.require(:referrals_referrer_name_form).permit(:name)
    end
  end
end
