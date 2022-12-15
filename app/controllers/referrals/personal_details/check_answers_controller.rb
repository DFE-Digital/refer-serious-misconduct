module Referrals
  module PersonalDetails
    class CheckAnswersController < Referrals::BaseController
      def edit
        @personal_details_check_answers_form =
          CheckAnswersForm.new(
            personal_details_complete:
              current_referral.personal_details_complete
          )
      end

      def update
        @personal_details_check_answers_form =
          CheckAnswersForm.new(
            check_answers_params.merge(referral: current_referral)
          )

        if @personal_details_check_answers_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      def back_link
        session[:return_to] ||
          edit_referral_personal_details_qts_path(current_referral)
      end
      helper_method :back_link

      private

      def check_answers_params
        params.fetch(:referrals_personal_details_check_answers_form, {}).permit(
          :personal_details_complete
        )
      end
    end
  end
end
