module Referrals
  module Allegation
    class CheckAnswersController < Referrals::BaseController
      def edit
        @allegation_check_answers_form =
          CheckAnswersForm.new(
            allegation_details_complete:
              current_referral.allegation_details_complete
          )
      end

      def update
        @allegation_check_answers_form =
          CheckAnswersForm.new(
            check_answers_params.merge(referral: current_referral)
          )

        if @allegation_check_answers_form.save
          redirect_to [:edit, current_referral.routing_scope, current_referral]
        else
          render :edit
        end
      end

      private

      def check_answers_params
        params.fetch(:referrals_allegation_check_answers_form, {}).permit(
          :allegation_details_complete
        )
      end
    end
  end
end
