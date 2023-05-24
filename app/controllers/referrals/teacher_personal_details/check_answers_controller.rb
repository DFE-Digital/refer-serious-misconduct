module Referrals
  module PersonalDetails
    class CheckAnswersController < Referrals::BaseController
      def edit
        @personal_details_check_answers_form =
          CheckAnswersForm.new(
            referral: current_referral,
            personal_details_complete: current_referral.personal_details_complete
          )
      end

      def update
        @personal_details_check_answers_form =
          CheckAnswersForm.new(check_answers_params.merge(referral: current_referral))

        if @personal_details_check_answers_form.save
          redirect_to @personal_details_check_answers_form.next_path
        else
          render :edit
        end
      end

      private

      def check_answers_params
        params.fetch(:referrals_personal_details_check_answers_form, {}).permit(
          :personal_details_complete
        )
      end
    end
  end
end
