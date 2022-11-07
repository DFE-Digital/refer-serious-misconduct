module Referrals
  class ReferrerJobTitleController < Referrals::BaseController
    def edit
      @referrer_job_title_form =
        ReferrerJobTitleForm.new(referral: current_referral)
    end

    def update
      @referrer_job_title_form =
        ReferrerJobTitleForm.new(
          job_title_params.merge(referral: current_referral)
        )
      if @referrer_job_title_form.save
        redirect_to edit_referral_referrer_phone_path(current_referral)
      else
        render :edit
      end
    end

    private

    def job_title_params
      params.require(:referrer_job_title_form).permit(:job_title)
    end
  end
end
