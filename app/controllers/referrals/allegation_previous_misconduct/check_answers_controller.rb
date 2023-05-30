module Referrals
  module AllegationPreviousMisconduct
    class CheckAnswersController < Referrals::BaseController
      def edit
        @form =
          CheckAnswersForm.new(
            referral: current_referral,
            previous_misconduct_complete: current_referral.previous_misconduct_complete
          )
      end

      def update
        @form = CheckAnswersForm.new(previous_misconduct_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
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
