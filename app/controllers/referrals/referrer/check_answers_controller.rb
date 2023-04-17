module Referrals
  module Referrer
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
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def set_referrer
        @referrer = current_referral.referrer
      end

      def referrer_params
        params.require(:referrals_referrer_check_answers_form).permit(:complete)
      end

      def next_path
        [:edit, current_referral.routing_scope, current_referral]
      end
    end
  end
end
