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
          redirect_to next_path
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

      def next_path
        edit_referral_path(current_referral)
      end
    end
  end
end
