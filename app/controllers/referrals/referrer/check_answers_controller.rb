module Referrals
  module Referrer
    class CheckAnswersController < BaseController
      def edit
        @referrer = current_referral.referrer
        @check_answers_form =
          CheckAnswersForm.new(referrer: @referrer, complete: @referrer.complete)
      end

      def update
        @check_answers_form =
          CheckAnswersForm.new(
            complete: referrer_params[:complete],
            referrer: current_referral.referrer,
            referral: current_referral
          )

        if @check_answers_form.save
          redirect_to next_page
        else
          @referrer = current_referral.referrer
          render :edit
        end
      end

      private

      def referrer_params
        params.require(:referrals_referrer_check_answers_form).permit(:complete)
      end

      def next_path
        [:edit, current_referral.routing_scope, current_referral]
      end
    end
  end
end
