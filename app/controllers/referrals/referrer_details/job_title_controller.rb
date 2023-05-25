module Referrals
  module ReferrerDetails
    class JobTitleController < Referrals::BaseController
      def edit
        @referrer_job_title_form =
          Referrals::ReferrerDetails::JobTitleForm.new(referral: current_referral)
      end

      def update
        @referrer_job_title_form =
          Referrals::ReferrerDetails::JobTitleForm.new(
            job_title_params.merge(referral: current_referral)
          )
        if @referrer_job_title_form.save
          redirect_to @referrer_job_title_form.next_path
        else
          render :edit
        end
      end

      private

      def job_title_params
        params.require(:referrals_referrer_details_job_title_form).permit(:job_title)
      end
    end
  end
end
