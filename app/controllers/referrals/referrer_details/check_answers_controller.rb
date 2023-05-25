module Referrals
  module ReferrerDetails
    class CheckAnswersController < BaseController
      before_action :set_referrer

      def edit
        @check_answers_form =
          CheckAnswersForm.new(
            referral: current_referral,
            referrer: @referrer,
            complete: @referrer.complete
          )
      end

      def update
        @check_answers_form =
          CheckAnswersForm.new(
            referral: current_referral,
            referrer: @referrer,
            complete: referrer_params[:complete]
          )

        if @check_answers_form.save
          redirect_to @check_answers_form.next_path
        else
          render :edit
        end
      end

      private

      def set_referrer
        @referrer = current_referral.referrer
      end

      def referrer_params
        params.require(:referrals_referrer_details_check_answers_form).permit(:complete)
      end
    end
  end
end
