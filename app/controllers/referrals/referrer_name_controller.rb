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
        redirect_to next_page
      else
        render :edit
      end
    end

    private

    def name_params
      params.require(:referrals_referrer_name_form).permit(:name)
    end

    def next_path
      [
        :edit,
        current_referral.routing_scope,
        current_referral,
        :referrer_job_title
      ]
    end
  end
end
