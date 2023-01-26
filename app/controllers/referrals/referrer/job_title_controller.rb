module Referrals
  module Referrer
    class JobTitleController < Referrals::BaseController
      def edit
        @referrer_job_title_form =
          Referrals::Referrer::JobTitleForm.new(referral: current_referral)
      end

      def update
        @referrer_job_title_form =
          Referrals::Referrer::JobTitleForm.new(
            job_title_params.merge(referral: current_referral)
          )
        if @referrer_job_title_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def job_title_params
        params.require(:referrals_referrer_job_title_form).permit(:job_title)
      end

      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :referrer_phone
        ]
      end
    end
  end
end
