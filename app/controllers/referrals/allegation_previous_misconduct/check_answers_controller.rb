module Referrals
  module AllegationPreviousMisconduct
    class CheckAnswersController < Referrals::BaseController
      def edit
        @previous_misconduct_check_answers_form =
          CheckAnswersForm.new(
            referral: current_referral,
            previous_misconduct_complete: current_referral.previous_misconduct_complete
          )
      end

      def update
        @previous_misconduct_check_answers_form =
          CheckAnswersForm.new(previous_misconduct_params.merge(referral: current_referral))

        if @previous_misconduct_check_answers_form.save
          redirect_to [:edit, current_referral.routing_scope, current_referral]
        else
          render :edit
        end
      end

      private

      def previous_misconduct_params
        params.require(:referrals_allegation_previous_misconduct_check_answers_form).permit(
          :previous_misconduct_complete
        )
      end
    end
  end
end
